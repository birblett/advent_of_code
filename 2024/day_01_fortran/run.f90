program run
    use stdlib_kinds, only: int8, int32
    use stdlib_sorting, only: sort
    use stdlib_hashmaps, only: chaining_hashmap_type, open_hashmap_type
    use stdlib_hashmap_wrappers, only: fnv_1_hasher, key_type, other_type, set, get
    implicit none
    character*256 :: TMP
    integer(int32) :: i, err = 0, N = -1, idx, cmp1, cmp2, p1 = 0, p2 = 0, t
    integer(int32), dimension (:), allocatable :: arr1, arr2
    class(*), allocatable :: data
    type int_t
        integer(int32) :: value
    end type int_t
    type(int_t) :: out
    type(chaining_hashmap_type), allocatable :: map
    type(key_type) :: key
    type(other_type) :: other
    logical :: has_key
    open(unit=1,file='in.txt')
    do while (err == 0)
        N = N + 1
        read(1,"(A)",iostat=err) TMP
    end do
    rewind(1)
    allocate(arr1(N))
    allocate(arr2(N))
    allocate(map)
    call map%init(fnv_1_hasher)
    do i = 1, N
        read(1,"(A)") TMP
        idx = scan(TMP," ")
        read(TMP(0:idx), *) arr1(i)
        TMP = trim(TMP(idx+3:))
        read(TMP, *) arr2(i)
        call set(key, [arr2(i)])
        call map%key_test(key, has_key)
        t = 0
        if (has_key) then
            call map%get_other_data(key, other)
            call get(other, data)
            select type(data)
            type is (int_t)
                t = data%value + 1
            end select
            data = int_t(t)
            call set(other, data)
            call map%set_other_data(key, other)
        else
            data = int_t(1)
            call set(other, data)
            call map%map_entry(key, other)
        end if
    end do
    call sort(arr1)
    call sort(arr2)
    do i = 1, N
        p1 = p1 + abs(arr1(i) - arr2(i))
        t = 0
        call set(key, [arr1(i)])
        call map%get_other_data(key, other, has_key)
        if (has_key) then
            call get(other, data)
            select type(data)
            type is (int_t)
                t = data%value
            end select
        end if
        p2 = p2 + (arr1(i) * t)
    end do
    print*,"p1: ", p1
    print*,"p2: ", p2
    close(1)
    deallocate(arr1)
    deallocate(arr2)
    deallocate(map)
end program run