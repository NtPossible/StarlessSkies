uniform float playerToSealevelOffset;
uniform int ditherSeed;
uniform int horizontalResolution;
uniform float fogWaveCounter;
uniform sampler2D glow; // sunlight.png
uniform sampler2D sky;   // sky.png
uniform float sunsetMod;


//	<https://www.shadertoy.com/view/4dS3Wd>
//	By Morgan McGuire @morgan3d, http://graphicscodex.com
//
float hash(float n) { return fract(sin(n) * 1e4); }
float hash(vec2 p) { return fract(1e4 * sin(17.0 * p.x + p.y * 0.1) * (0.1 + abs(sin(p.y * 13.0 + p.x)))); }

float noise(float x) {
	float i = floor(x);
	float f = fract(x);
	float u = f * f * (3.0 - 2.0 * f);
	return mix(hash(i), hash(i + 1.0), u);
}

float noise(vec3 x) {
	const vec3 step = vec3(110, 241, 171);

	vec3 i = floor(x);
	vec3 f = fract(x);
 
	// For performance, compute the base input to a 1D hash from the integer part of the argument and the 
	// incremental change to the 1D based on the 3D -> 1D wrapping
    float n = dot(i, step);

	vec3 u = f * f * (3.0 - 2.0 * f); 
	return mix(mix(mix( hash(n + dot(step, vec3(0, 0, 0))), hash(n + dot(step, vec3(1, 0, 0))), u.x),
                   mix( hash(n + dot(step, vec3(0, 1, 0))), hash(n + dot(step, vec3(1, 1, 0))), u.x), u.y),
               mix(mix( hash(n + dot(step, vec3(0, 0, 1))), hash(n + dot(step, vec3(1, 0, 1))), u.x),
                   mix( hash(n + dot(step, vec3(0, 1, 1))), hash(n + dot(step, vec3(1, 1, 1))), u.x), u.y), u.z);
}


float getFogAmountForSky(vec3 skyPosition, vec3 skyPosNorm, float sealevelOffsetFactor, float horizonFog) {
	float fStart = flatFogDensity < 0 ? flatFogStart : 0;
	float earthCurvatureBias = flatFogDensity < 0 ? 0.55 * playerToSealevelOffset : 0; // Add a bit of bias because distant sky has earth curvature?
	float invHorizonDistance = (1 - skyPosNorm.y)/2 + 0.3;
	
	// Apply fog
	float fogAmount = max(
		fogMinIn + max(fogDensityIn * 120 - 0.12, 0) + max(-flatFogDensity * gl_FragCoord.z * fStart / 3.3, 0), 
		(1 - 1 / exp((skyPosition.y - fStart - earthCurvatureBias) * flatFogDensity))
	);
	
	// Add a little extra fog near the horizon
	float f = 0;
	
	float rnd = fogWaveCounter / 1.0;
	vec3 rndPos = vec3(rnd + skyPosNorm.x, skyPosNorm.y, skyPosNorm.z - rnd);
	
	float density = invHorizonDistance * (0.6 + noise(rndPos)/3);

	float fac = max(0, density - 0.5) * max(min(1, 5 * fogAmount), horizonFog);
	fogAmount += fac;
	
	fogAmount = clamp(fogAmount, 0, 1);
	
	return fogAmount;
}

// MODNOTE: Wiped out bacally everything here, no sky, no glow
void getSkyColorAt(vec3 skyPosition, vec3 sunPosition, float sealevelOffsetFactor, float skyLightIntensity, float horizonFog, out vec4 skyColor, out vec4 skyGlow)
{
    skyColor = vec4(0.0, 0.0, 0.0, 1.0);
    skyGlow  = vec4(0.0, 0.0, 0.0, 1.0);
    return;
}


// MODNOTE: Wiped out bacally everything here, no sky, no glow
vec4 getSkyGlowAt(vec3 skyPosition, vec3 sunPosition, float sealevelOffsetFactor, float skyLightIntensity, float horizonFog, float proximityMul)
{
    return vec4(0.0, 0.0, 0.0, 1.0);
}


