program vasp_poscar_analyzer
    implicit none

    ! Variable declarations
    integer :: i
    double precision, parameter :: PI = 3.141592653589793238
    double precision :: factor, a_v(3), b_v(3), c_v(3)
    double precision :: a, b, c, alpha, beta, gamma, volume, rad_to_deg
    character(len=256) :: poscar

    ! Conversion factor from radians to degrees
    rad_to_deg = 180.0 / PI

    ! Retrieve POSCAR filename from command line argument
    call getarg(1, poscar)

    ! Read lattice vectors from POSCAR file
    open(unit=501, file=poscar, status="old")
    read(501,*)           ! Skip comment line
    read(501,*) factor    ! Scaling factor
    read(501,*) a_v       ! Lattice vector a
    read(501,*) b_v       ! Lattice vector b
    read(501,*) c_v       ! Lattice vector c
    close(501)

    ! Scale lattice vectors by the factor
    do i = 1, 3
        a_v(i) = factor * a_v(i)
        b_v(i) = factor * b_v(i)
        c_v(i) = factor * c_v(i)
    end do

    ! Calculate magnitudes of lattice vectors
    a = sqrt(sum(a_v**2))
    b = sqrt(sum(b_v**2))
    c = sqrt(sum(c_v**2))

    ! Compute cell volume using the triple product |a_v x b_v . c_v|
    volume = dot_product(cross_product(a_v, b_v), c_v)

    ! Calculate angles between lattice vectors in degrees
    alpha = acos(dot_product(b_v, c_v) / (b * c)) * rad_to_deg
    beta = acos(dot_product(c_v, a_v) / (c * a)) * rad_to_deg
    gamma = acos(dot_product(a_v, b_v) / (a * b)) * rad_to_deg

    ! Print results to screen
    print 100, 'a = ', a, '(Å)'
    print 100, 'b = ', b, '(Å)'
    print 100, 'c = ', c, '(Å)'
    print 100, 'alpha = ', alpha, '(°)'
    print 100, 'beta = ', beta, '(°)'
    print 100, 'gamma = ', gamma, '(°)'
    print 100, 'volume = ', volume, '(Å³)'

    ! Comma-separated values for easy export
    print 200, a, ',', b, ',', c, ',', alpha, ',', beta, ',', gamma, ',', volume

100 format (A9, F18.11, A15)
200 format (F12.4, A, F12.4, A, F12.4, A, F12.4, A, F12.4, A, F12.4, A, F12.4)

contains

    ! Function to compute cross product of two vectors
    function cross_product(a, b)
        double precision, dimension(3) :: cross_product
        double precision, dimension(3), intent(in) :: a, b

        cross_product(1) = a(2) * b(3) - a(3) * b(2)
        cross_product(2) = a(3) * b(1) - a(1) * b(3)
        cross_product(3) = a(1) * b(2) - a(2) * b(1)
    end function cross_product

end program vasp_poscar_analyzer
