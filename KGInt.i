%module  KGInt

%{
    #define SWIG_FILE_WITH_INIT

    extern double integrate(const int& N, double * result, double * rs, double * alphas, double *errors, double * error_rngs);
%}

%include "numpy.i"

%init %{
    import_array();
%}

%apply (int DIM1, double* ARGOUT_ARRAY1) {(int n1, double* result)}
%apply (int DIM1, double* IN_ARRAY1){(int n2, double *rs), (int n3, double * alphas), (int n4, double *errors), (int n5, double *error_rngs)}

%feature("autodoc", "1");
extern double integrate(const int& N, double * result, double * rs, double * alphas, double *errors, double * error_rngs);

%rename (integrate) swig_integrate;

%inline %{
    double integrate(int n1, double * result, int n2, double * rs, int n3, double * alphas, int n4, double * errors, int n5, double * error_rngs){
        if ( n2!=n3 || n3!=n4 || n4!=n5){
            PyErr_Format(PyExc_ValueError, "Array sizes doesn't match (%d, %d, %d, %d, %d)!", n1, n2, n3, n4, n5);
            return 0;
        }
        return integrate(n2, result, rs, alphas, errors, error_rngs);
    }
%}

%pythoncode %{
    def integrate(rs, alphas, errors, error_rngs, time=True):
        res = _KGInt.integrate(len(rs)*2, rs, alphas, errors, error_rngs)
        if time:
            print("Elapsed time: %.1f ms"%res[0])
        return res[1].reshape(len(rs),2);
%}