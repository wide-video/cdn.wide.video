const fs = require('fs');
const path = require('path');
const root = __dirname;

// some old versions can be removed
// some files are > 25MB https://developers.cloudflare.com/pages/platform/limits/#file-size
const removePaths = [
	/\/ffmpeg\/0\.[0-8]\./,
	/\/ffmpeg\/0\.9\.0\//,
	/\/piper\/0\.0\.0\//,
	/\/rive\/2\.7/
]

// cloudflare limit is 100 header rules
// https://developers.cloudflare.com/pages/configuration/headers/
let headerRulesCount = 1;
let headers = `/*
	Access-Control-Allow-Headers: *
	Access-Control-Allow-Origin: *
	Access-Control-Expose-Headers: *
	Cache-Control: public, max-age=604800, s-maxage=604800, immutable
	Cross-Origin-Opener-Policy: same-origin
	Cross-Origin-Embedder-Policy: require-corp
	Cross-Origin-Resource-Policy: cross-origin\n\n`;

function readFileSync(path) {
	try {
		return fs.readFileSync(path, 'utf8');
	} catch {}
}

function renameBrFilesSync(dir) {
	const files = fs.readdirSync(dir);
	const htaccess = readFileSync(path.join(dir, ".htaccess"));

	fileLoop:for(const file of files) {
		const filePath = path.join(dir, file);
		const stats = fs.statSync(filePath);

		for(const removePath of removePaths)
			if(filePath.match(removePath)) {
				console.log(`Removed: ${filePath} by rule ${removePath}`);
				fs.rmSync(filePath, {recursive:true});
				continue fileLoop;
			}

		if(stats.isDirectory()) {
			renameBrFilesSync(filePath);
			continue;
		} 
		
		if(stats.isFile() && path.extname(file) === '.br') {
			const newFilePath = filePath.replace(/\.br$/, '');
			const newRelativeFilePath = path.relative(root, newFilePath);

			fs.renameSync(filePath, newFilePath);
			console.log(`Renamed: ${filePath} -> ${newFilePath}`);

			let contentLength = 0;
			if(htaccess) {
				const filePattern = file.replaceAll(".", "\\\\?.");
				const pattern = `<FilesMatch.*?${filePattern}.*?x-content-length (\\d+)`;
				const match = htaccess.match(new RegExp(pattern, "s"));
				if(match && match.length > 0)
					contentLength = match[1];
			}

			if(!contentLength)
				throw new Error(`ContentLength not available for ${filePath}`);

			headerRulesCount++;
			headers += `/${newRelativeFilePath}\n`
				+ `\tContent-Encoding: br\n`
				+ `\tCache-Control: no-transform\n`
				+ `\tx-content-length: ${contentLength}\n\n`;
		}
	}
}

renameBrFilesSync(root);

console.log(`creating _headers file with ${headerRulesCount} rules.`);
console.log(headers);
fs.writeFileSync("_headers", headers, 'utf8');