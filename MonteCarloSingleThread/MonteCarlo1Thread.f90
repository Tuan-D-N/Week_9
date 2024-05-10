module monteCarloInt
   implicit none

contains
   function random() result(retval)
      real :: retval
      call random_number(retval)
   end function random

   real function integrate1D(a,b,n)

      integer, intent(in) :: n
      integer :: i
      real, intent(in) :: a, b
      real :: x, sum
      ! Initialize the sum
      sum = 0.0

      ! Perform the Monte Carlo integration
      do i = 1, n
         ! Generate a random point between a and b
         x = a + (b - a) * random()
         ! Add the value of the integrand at the random point to the sum
         sum = sum + f1D(x)
      end do

      ! Calculate the integral
      integrate1D = (b - a) * sum / real(n)

   end function integrate1D

   real function integrateND(bounds,n,dim)
      integer, intent(in) :: n, dim
      integer :: i
      real, intent(in) :: bounds(:) !Stored in pairs
      real,allocatable :: a(:), b(:)
      real, allocatable :: x(:)
      real :: sum
! Initialize the sum
      sum = 0.0

      allocate(a(size(bounds)/2), b(size(bounds)/2))
      a = bounds(1::2) !Lowerbounds
      b = bounds(2::2) !Higherbounds

      allocate (x(dim))
      do i = 1, n
         ! Generate a random point between a and b
         call random_number(x)


         x = a + (b - a) * x
         ! Add the value of the integrand at the random point to the sum
         sum = sum + f(x)
      end do

      ! Calculate the integral
      integrateND = product(b - a) * sum / real(n)

   end function integrateND
   ! Define the integrand function
   real function f(x)
      real, intent(in) :: x(:)
      f = exp(-x(1)-x(2)-x(3)) ! Example integrand: x^2
   end function f


   ! Define the integrand function
   real function f1D(x)
      real, intent(in) :: x
      f1D = x**2 ! Example integrand: x^2
   end function f1D
end module monteCarloInt

program monte_carlo_integration
   use monteCarloInt
   implicit none
   real, allocatable :: bounds(:)
   real :: exact = 0.80656718084400884701
   integer :: n, dim, index
   real:: startTime, stopTime

   call cpu_time(startTime)

   allocate(bounds(6))
   bounds = [0,2,0,3,0,4]
   dim = 3

   open(unit = 2, file = "MonteCarloOut.dat")
   do index = 1, 28

      n = 2**index
      write(2, *) n, integrateND(bounds,n,dim), (exact-integrateND(bounds,n,dim))/exact
   end do

   call cpu_time(stopTime)

   write(2,*) stopTime-startTime

end program monte_carlo_integration
