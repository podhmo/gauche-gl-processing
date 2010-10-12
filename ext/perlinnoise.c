/* Generated automatically from perlinnoise.scm.  DO NOT EDIT */
#include <gauche.h>
#include <gauche/code.h>
#include <gauche/macro.h>
#include <gauche/extend.h>
#if defined(__CYGWIN__) || defined(GAUCHE_WINDOWS)
#define SCM_CGEN_CONST /*empty*/
#else
#define SCM_CGEN_CONST const
#endif
static SCM_CGEN_CONST struct scm__scRec {
  ScmString d1005[2];
} scm__sc = {
  {   /* ScmString d1005 */
      SCM_STRING_CONST_INITIALIZER("ext.perlinnoise", 15, 15),
      SCM_STRING_CONST_INITIALIZER("perlinnoise-2d", 14, 14),
  },
};
static struct scm__rcRec {
  ScmObj d1004[1];
} scm__rc = {
  {   /* ScmObj d1004 */
    SCM_UNBOUND,
  },
};

#include <stdio.h>
#include <math.h>

static const float pi = atan(1.0)*4;

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

static ScmObj perlinnoiseperlinnoise_2d(ScmObj *SCM_FP, int SCM_ARGCNT, void *data_)
{
  ScmObj x_scm;
  float x;
  ScmObj y_scm;
  float y;
  ScmObj persistence_scm;
  float persistence;
  ScmObj octaves_scm;
  float octaves;
  SCM_ENTER_SUBR("perlinnoise-2d");
  x_scm = SCM_ARGREF(0);
  if (!SCM_REALP(x_scm)) Scm_Error("real number required, but got %S", x_scm);
  x = (float)Scm_GetDouble(x_scm);
  y_scm = SCM_ARGREF(1);
  if (!SCM_REALP(y_scm)) Scm_Error("real number required, but got %S", y_scm);
  y = (float)Scm_GetDouble(y_scm);
  persistence_scm = SCM_ARGREF(2);
  if (!SCM_REALP(persistence_scm)) Scm_Error("real number required, but got %S", persistence_scm);
  persistence = (float)Scm_GetDouble(persistence_scm);
  octaves_scm = SCM_ARGREF(3);
  if (!SCM_REALP(octaves_scm)) Scm_Error("real number required, but got %S", octaves_scm);
  octaves = (float)Scm_GetDouble(octaves_scm);
  {
{
ScmObj SCM_RESULT;

#line 63 "perlinnoise.scm"
SCM_RESULT=(Scm_MakeFlonum(perlinnoise_2d(x,y,persistence,octaves)));
SCM_RETURN(SCM_OBJ_SAFE(SCM_RESULT));
}
  }
}

static SCM_DEFINE_SUBRI(perlinnoiseperlinnoise_2d__STUB, 4, 0, SCM_OBJ(&scm__sc.d1005[1]), perlinnoiseperlinnoise_2d, NULL, NULL);

static ScmCompiledCode *toplevels[] = {
 NULL /*termination*/
};
SCM_EXTENSION_ENTRY void Scm_Init_perlinnoise() { ScmModule *mod;
SCM_INIT_EXTENSION(perlinnoise);
  scm__rc.d1004[0] = Scm_Intern(SCM_STRING(SCM_OBJ(&scm__sc.d1005[0]))); /* ext.perlinnoise */
  mod = Scm_FindModule(SCM_SYMBOL(scm__rc.d1004[0]),SCM_FIND_MODULE_CREATE);
  Scm_SelectModule(mod);
  SCM_DEFINE(mod, "perlinnoise-2d", SCM_OBJ(&perlinnoiseperlinnoise_2d__STUB));
  Scm_VMExecuteToplevels(toplevels);
}
