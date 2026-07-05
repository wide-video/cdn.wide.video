const float kCellCount = 20.0;   // 屏幕切分为多少个额cell
const float kCircleMin1 = 0.2;
const float kCircleInc1 = 0.05;
const float kCircleMin2 = 0.4;
const float kCircleInc2 = 0.1;
const float kThreshold = 0.4;
const vec4 kToneColor = vec4(1.0,0.5,0.2,1.0);

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord/iResolution.xy;
	float ratio = iResolution.y / iResolution.x;
	uv = uv * vec2(1.0/ratio,1.0);
	vec2 uvf = fract(uv * kCellCount);   // 小数部分. 切分为 正方形 cell 的 uv
	vec2 uvi = floor(uv * kCellCount);   // 整数部分
	fragColor = vec4(uvf,0.0,1.0);
	vec2 expandUVRange = vec2(1.0/ratio,1.0) * kCellCount;  
	vec2 mosaicUV = (uvi + 0.5) / expandUVRange; // 这里的 0.5, 表示颜色获取每个cell 的 中心位置的意思
	vec4 texCol = texture(iChannel0,mosaicUV);
	fragColor = texCol;
	float gray = dot(texCol.rgb, vec3(0.299, 0.587, 0.114));
	float d = distance(uvf,vec2(0.5,0.5));
	float c1 = mix(kCircleMin1,kCircleMin2,step(kThreshold,gray));
	float c2 = mix(kCircleMin1+kCircleInc1,kCircleMin2+kCircleInc2,step(kThreshold,gray));       
	float v = 1.0 - smoothstep(c1,c2,d);
	fragColor = v * kToneColor;
}