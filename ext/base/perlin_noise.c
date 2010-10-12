#include <stdio.h>
#include <math.h>

float pi = atan(1.0)*4;

float noise(int x, int y){
  int n = x + y * 57;
  n = (n<<13) ^ n;
  return ( 1.0 - ( (n * (n * n * 15731 + 789221) + 1376312589) & 0x7fffffff) / 1073741824.0);    
}

float smooth_noise(float x, float y){
  float corners = ( noise(x-1, y-1)+noise(x+1, y-1)+noise(x-1, y+1)+noise(x+1, y+1) ) / 16;
  float sides   = ( noise(x-1, y)  +noise(x+1, y)  +noise(x, y-1)  +noise(x, y+1) ) /  8;
  float center  =  noise(x, y) / 4;
  return corners + sides + center;
}

//cosine interpolate
float interpolate(float a, float b, float x){
  float ft = x * pi;
  float f = (1 - (cos(ft))) * 0.5;
  return a * (1-f) + b*f;
}

float interpolated_noise(float x, float y){
  int integer_X    = (int)x;
  float fractional_X = x - integer_X;
  int integer_Y    = (int)y;
  float fractional_Y = y - integer_Y;

  float v1 = smooth_noise(integer_X,     integer_Y);
  float v2 = smooth_noise(integer_X + 1, integer_Y);
  float v3 = smooth_noise(integer_X,     integer_Y + 1);
  float v4 = smooth_noise(integer_X + 1, integer_Y + 1);

  float i1 = interpolate(v1 , v2 , fractional_X);
  float i2 = interpolate(v3 , v4 , fractional_X);

  return interpolate(i1 , i2 , fractional_Y);
}

float perlinnoise_2d(float x, float y, float persistence, float octaves){
  float total = 0;
  float p = persistence;
  float n = octaves - 1;
  for (int i=0; i<n; i++){
    float frequency = pow(2,i);
    float amplitude = pow(pi,i);
    total = total + interpolated_noise(x * frequency, y * frequency) * amplitude;
  }
  return total;
}

int main(int argc, char *argv[]){
  float persistence = 0.2;
  float octaves = 8.0;
  for(int i=0; i<10; i++){
    for(int j=0; j<10; j++){
      float tmp = perlinnoise_2d(i,j,persistence,octaves);
      int c = ((int)(tmp*255)) & 0xff;
      printf("%d\n", c);
    }
  }
}
