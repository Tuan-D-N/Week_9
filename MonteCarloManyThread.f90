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
   include "mpif.h"

   real, allocatable :: bounds(:)
   real :: exact = 0.80656718084400884701
   integer :: n, dim, index
   real:: startTime, stopTime

   integer, parameter :: seed_size = 8
   integer :: seed(seed_size)

   ! declare variables
   integer rank    ! value corresponding to this MPI process
   integer total   ! total number of MPI processes
   integer err     ! error code returned by MPI calls (not checked)

   real :: send_buff(1), recv_buff(1)

   ! Set the seed values to the current time
   call date_and_time(values=seed)

   ! Set the random seed
   call random_seed(put=seed)


   call cpu_time(startTime)

   allocate(bounds(6))
   bounds = [0,2,0,3,0,4]
   dim = 3




   ! initialise the MPI implementation
   call MPI_INIT(err)

   ! determine the size of the MPI_COMM_WORLD communicator
   call MPI_COMM_SIZE(MPI_COMM_WORLD, total, err)

   ! determine the rank of this MPI process in the MPI_COMM_WORLD communicator
   call MPI_COMM_RANK(MPI_COMM_WORLD, rank, err)

   ! print rank and size to standard output

   ! finalise the MPI implementation


   open(unit = 2, file = "MonteCarloOutMultithread.dat")
   do index = 5, 28
      n = ceiling(2**index/total)

      send_buff = integrateND(bounds,n,dim)
      call MPI_REDUCE(send_buff, recv_buff, 1, MPI_FLOAT, MPI_SUM, 0, MPI_COMM_WORLD, err)

      print*, "rank: ", rank, "send_buff: ", send_buff, "n ", n
      recv_buff(1) = recv_buff(1) / total

      if ( rank == 0 ) then
         write(2, *) n, recv_buff(1), (exact-recv_buff(1))/exact
         print *, "receive: ", recv_buff, "error: ", (exact-recv_buff(1))/exact
      end if

   end do






   call MPI_FINALIZE(err)


   call cpu_time(stopTime)

   write(2,*) stopTime-startTime

end program monte_carlo_integration

