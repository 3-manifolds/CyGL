# cython: language_level=3str

"""
This extension module provides one Python function named gl_context_exists.
It returns True or False according to whether an OpenGL context has been
created.

On linux and macOS, when the library is first loaded it is in a state
where its pointer to the current GL context is NULL.  Worse, no GL function
tests that pointer.  Instead, a call to any GL function when the library is
in its initial state will produce a segfault. On Windows, at least
some openGL calls can run without a segfault but they produce errors.
Ror example, glGetString will return NULL.

The gl_context_exists function works on Unix by installing a SIGSEGV
handler and then calling GLGetString.  If the handler gets called then
the function returns False.  Otherwise it returns True.  On Windows
it returns false if glGetString return NULL and True otherwise.

Handling a SIGSEGV signal is delicate business.  Most handlers simply try to
do some custom clean-up and/or error reporting and then terminate the program.
This avoids the key issue, which is that if a SIGSEGV handler is allowed to
return then execution will resume at the exact same instruction which caused
the segfault in the first place, and the relevant address register will still
contain the same bad address, so the fault will recur.  A workaround is to
prevent the handler from returning by having it jump back into the program,
but with the program state altered so that the culprit function will not be
called after the jump.  With one caveat, this can be done by using the setjmp
and longjmp functions.  The caveat is that this only works if the signal handler
is running on the same stack as the program.  Unfortunately, this is never the
case with a SIGSEGV handler on Windows.  However, it is true that a SIGFPE
handler does run on the same stack on Windows.  So a workaround is possible by
having the SIGSEGV handler raise a SIGFPE and having the SIGFPE handler call
setjmp.
"""

from cygl.common cimport *

cdef extern from *:
    r"""
/* This C code will be inserted verbatim into the file generated by Cython. */

#ifdef _WIN32

static void set_handler(void) {
}

static void clear_handler(void) {
}

static int check_for_context(void) {
    char *version = (char *) glGetString(GL_VERSION);
    return (version == NULL);
}

static int initialize_context(void) {
    GLenum err = glewInit();
    if (GLEW_OK != err) {
        fprintf(stderr, "Error: %s\n", glewGetErrorString(err));
    }
    fprintf(stdout, "Status: Using GLEW %s\n", glewGetString(GLEW_VERSION));
    return err;
}

#else

#include <signal.h>
#include <setjmp.h>

static sighandler_t saved_segv_handler = SIG_DFL;
static jmp_buf jmp_env;

static void jumper(int signum) {
    longjmp(jmp_env, 1);
}

static void set_handler(void) {
    saved_segv_handler = signal(SIGSEGV, jumper);
}

static void clear_handler(void) {
    signal(SIGSEGV, saved_segv_handler);
}

static int check_for_context(void) {

    /*
     * The longjmp jumps to the asssignment below, but with the return
     * value of setjmp set to 1 instead of 0.
     */

    int jmp_return = setjmp(jmp_env);
    if (jmp_return == 0) {
        char *version = (char *) glGetString(GL_VERSION);
	printf("%s\n", version);
    }
    return jmp_return;
}

static int initialize_context(void) {
    return 0;
}

#endif

"""

    cdef void set_handler()
    cdef void clear_handler()
    cdef int check_for_context()
    cdef int initialize_context()

def gl_context_exists():
    set_handler()
    result = check_for_context()
    clear_handler()
    if result:
        return False
    return True

def gl_init_context():
   return (initialize_context() == 0)
