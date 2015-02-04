# chapter1/programs_and_modules/ODEschemes.py

import numpy as np
from matplotlib.pyplot import plot, show, legend, hold,rcParams,rc, figure, axhline, close,\
    xticks, xlabel, ylabel, savefig, axis, grid

# change some default values to make plots more readable 
LNWDT=3; FNT=11
rcParams['lines.linewidth'] = LNWDT; rcParams['font.size'] = FNT
font = {'size' : 16}; rc('font', **font)


# define Euler solver
def euler(func, z0, time):
    """The Euler scheme for solution of systems of ODEs.
    z0 is a vector for the initial conditions,
    the right hand side of the system is represented by func which returns
    a vector with the same size as z0 ."""

    z = np.zeros((np.size(time), np.size(z0)))
    z[0,:] = z0

    for i in range(len(time)-1):
        dt = time[i+1] - time[i]
        z[i+1,:]=z[i,:] + np.asarray(func(z[i,:], time[i]))*dt

    return z

def euler2(func, z0, time):
    """The Euler scheme for solution of systems of ODEs.
    z0 is a vector for the initial conditions,
    the right hand side of the system is represented by func which returns
    a vector with the same size as z0 ."""

    def f_np(z,t):
        return np.asarray(func(z, t))

    z = np.zeros((np.size(time), np.size(z0)))
    z[0,:] = z0

    for i, t in enumerate(time[0:-1]):
        dt = time[i+1] - t
        z[i+1,:]=z[i,:] + f_np(z[i,:],t)*dt

    return z

def euler3(func, z0, time):
    """The Euler scheme for solution of systems of ODEs.
    z0 is a vector for the initial conditions,
    the right hand side of the system is represented by func which returns
    a vector with the same size as z0 ."""

    time_local = np.asarray(time)
    z = np.zeros((np.size(time_local), np.size(z0)))
    z[0,:] = float(z0)

    for i, t in enumerate(time_local[0:-1]):
        dt = time_local[i+1] - t
        z[i+1,:] = z[i,:] + np.asarray(func(z[i,:], t))*dt

    return z

def euler4(func, z0, time):
    """The Euler scheme for solution of systems of ODEs.
    z0 is a vector for the initial conditions,
    the right hand side of the system is represented by func which returns
    a vector with the same size as z0 ."""

    time_local = np.asarray(time)
    z = np.zeros((np.size(time_local), np.size(z0)))
    z[0,:] = float(z0)

    for i, t in enumerate(time_local[1:]):
        dt = t - time_local[i]
        z[i+1,:]=z[i,:] + np.asarray(func(z[i,:], time_local[i]))*dt

    return z

# define Heun solver
def heun(func, z0, time):
    """The Heun scheme for solution of systems of ODEs.
    z0 is a vector for the initial conditions,
    the right hand side of the system is represented by func which returns
    a vector with the same size as z0 ."""

    def f_np(z,t):
        """A local function to ensure that the return of func is an np array
        and to avoid lengthy code for implementation of the Heun algorithm"""
        return np.asarray(func(z,t))

    z = np.zeros((np.size(time), np.size(z0)))
    z[0,:] = z0
    zp = np.zeros_like(z0)

    for i, t in enumerate(time[0:-1]):
        dt = time[i+1] - time[i]
        zp = z[i,:] + f_np(z[i,:],t)*dt   # Predictor step
        z[i+1,:] = z[i,:] + (f_np(z[i,:],t) + f_np(zp,t+dt))*dt/2.0 # Corrector step

    return z

def heun2(func, z0, time):
    """The Heun scheme for solution of systems of ODEs.
    z0 is a vector for the initial conditions,
    the right hand side of the system is represented by func which returns
    a vector with the same size as z0 ."""

    z = np.zeros((np.size(time), np.size(z0)))
    z[0,:] = z0
    zp = np.zeros_like(z0)

    for i, t in enumerate(time[0:-1]):
        dt = time[i+1] - time[i]
        zp = z[i,:] + np.asarray(func(z[i,:],t))*dt   # Predictor step
        z[i+1,:] = z[i,:] + (np.asarray(func(z[i,:],t)) + np.asarray(func(zp,t+dt)))*dt/2.0 # Corrector step

    return z

# define rk4 scheme
def rk4(func, z0, time):
    """The Runge-Kutta 4 scheme for solution of systems of ODEs.
    z0 is a vector for the initial conditions,
    the right hand side of the system is represented by func which returns
    a vector with the same size as z0 ."""

    z = np.zeros((np.size(time),np.size(z0)))
    z[0,:] = z0
    zp = np.zeros_like(z0)

    for i, t in enumerate(time[0:-1]):
        dt = time[i+1] - time[i]
        dt2 = dt/2.0
        k1 = np.asarray(func(z[i,:], t))                # predictor step 1
        k2 = np.asarray(func(z[i,:] + k1*dt2, t + dt2)) # predictor step 2
        k3 = np.asarray(func(z[i,:] + k2*dt2, t + dt2)) # predictor step 3
        k4 = np.asarray(func(z[i,:] + k3*dt, t + dt))   # predictor step 4
        z[i+1,:] = z[i,:] + dt/6.0*(k1 + 2.0*k2 + 2.0*k3 + k4) # Corrector step

    return z


if __name__ == '__main__':
    a = 0.2
    b = 3.0
    u_exact = lambda t: a*t   +  b

    def f_local(u,t):
        """A function which returns an np.array but less easy to read
        than f(z,t) below. """
        return np.asarray([a + (u - u_exact(t))**5])

    def f(z, t):
        """Simple to read function implementation """
        return [a + (z - u_exact(t))**5]


    def test_ODEschemes():
        """Use knowledge of an exact numerical solution for testing."""
        from numpy import linspace, size

        tol = 1E-15
        T = 2.0  # end of simulation
        N = 20  # no of time steps
        time = linspace(0, T, N+1)


        z0 = np.zeros(1)
        z0[0] = u_exact(0.0)

        scheme_list  = [euler, euler2, euler3, euler4, heun, heun2, rk4]

        for scheme in scheme_list:
            z = scheme(f, z0, time)
            max_error = np.max(u_exact(time) - z[:,0])
            msg = '%s failed with error = %g' % (scheme.func_name, max_error)
            assert max_error < tol, msg

    # f3 defines an ODE with ananlytical solution in u_nonlin_analytical
    def f3(z, t,a=2.0,b=-1.0):
        """ """
        return a*z + b

    def u_nonlin_analytical(u0, t, a=2.0, b=-1.0):
        from numpy import exp
        TOL = 1E-14
        if (abs(a)>TOL):
            return (u0 + b/a)*exp(a*t)-b/a
        else:
            return u0 + b*t
            
 
        
    # Function for convergence test
    def test_convergence():
        """ Test convergence rate of the methods """
        from numpy import linspace, size, abs, log10, mean, log2
        figure()
        tol = 1E-15
        T = 8.0   # end of simulation
        Ndts = 5 # Number of times to refine timestep in convergence test

        z0 = 2

#        scheme_list  = [euler, euler2, euler3, euler4, heun, heun2, rk4]
        scheme_list =[euler, heun, rk4]
        legends=[]
        all_errors={}
        
        colors = ['r', 'g', 'b', 'm', 'k', 'y', 'c']
        linestyles = ['-', '--', '-.', ':', 'v--', '*-.']
        iclr = 0
        for scheme in scheme_list:
            N = 30    # no of time steps
            time = linspace(0, T, N+1)

            error_diff = []
            
            for i in range(Ndts+1):
                z = scheme(f3, z0, time)   
                abs_error = abs(u_nonlin_analytical(z0, time)-z[:,0])
                log_error = log2(abs_error[1:]) # Drop first element as it is always zero to avoid log10-problems
                max_log_err = max(log_error)
                plot(time[1:], log_error, linestyles[i]+colors[iclr], markevery=N/5)
                legends.append(scheme.func_name +': N = ' + str(N))
                hold('on')
                
                if i > 0: # Compute the log10 error difference
                    error_diff.append(previous_max_log_err - max_log_err) 
                previous_max_log_err = max_log_err
                
                
                N *=2
                time = linspace(0, T, N+1)
            
            all_errors[scheme.func_name] = error_diff
#             print error_diff
#             print mean(error_diff), 10**(mean(error_diff)), error_diff
#             print 10**np.asarray(error_diff)
            iclr += 1

        legend(legends, loc='best')
        xlabel('Time')
        ylabel('log(error)')
        grid()
        
        N = N/2**Ndts
        N_list = [N*2**i for i in range(1, Ndts+1)]
        N_list = np.asarray(N_list)
#         print N_list         
        
        figure()
        for key in all_errors:
            plot(N_list, (np.asarray(all_errors[key])))
        
        # Plot theoretical error reductions for first, second and fourth order schemes
        axhline(1.0, xmin=0, xmax=N, linestyle=':', color='k')
        axhline(2.0, xmin=0, xmax=N, linestyle=':', color='k')
        axhline(4.0, xmin=0, xmax=N, linestyle=':', color='k')
        xticks(N_list)
        legends = all_errors.keys()
        legends.append('theoretical') 
        legend(legends, loc='best', frameon=False)
        xlabel('Number of unknowns')
        ylabel('Error reduction when reducing timestep by two')
        axis([0, max(N_list), 0, 5])
        savefig('ConvergenceODEschemes.png', transparent=True)
        
    def plot_ODEschemes_solutions():
        """Plot the solutions for the test schemes in scheme_list"""
        from numpy import linspace
        figure()
        T = 1.5  # end of simulation
        N = 50  # no of time steps
        time = linspace(0, T, N+1)

        z0 = 2.0
        #scheme_list  = [euler,euler2, euler3, euler4,heun, heun2, rk4]
        scheme_list  = [euler, heun, rk4]
        legends = []


        for scheme in scheme_list:
            z = scheme(f3, z0, time)
            plot(time, z[:,-1])
            legends.append(scheme.func_name)

        plot(time, u_nonlin_analytical(z0, time))
        legends.append('analytical')
        legend(legends, loc='best', frameon=False)


    test_ODEschemes()
    test_convergence()
    plot_ODEschemes_solutions()
#     print rcParams.keys()
    show()
