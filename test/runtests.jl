
using Test
using Horde

function example_test()
    # Test stuff here.
    ret = (1==1)
    return ret
end

function tests()
    @testset "Tests" begin
        @testset "Example Test" begin
            @test example_test() == true
        end
    end
end


# ==================
# ---  GVF Tests ---
# ==================

function test_construction(obj_class, args...)
    try
        obj_class(args...)
        return true
    catch y
        @show y
        return false
    end
end

function gvf_tests()
    @testset "GVFArgs Tests" begin
        @test test_construction(GVFArgs, rand(3), 1, rand(3), 3, rand(5))
        @test test_construction(GVFArgs, rand(3), 1, rand(3), 3, complex.(rand(5),rand(5)))
        @test test_construction(GVFArgs, rand(3), 1, rand(3), rand(5))
        @test test_construction(GVFArgs, rand(3), 1)
        @test test_construction(GVFArgs, rand(3), rand(3))
        @test test_construction(GVFArgs, rand(3))
    end

    @testset "Discount Tests" begin
        @testset "Constant Discount" begin
            # discount builds
            @test test_construction(ConstantDiscount, 0.9)
            @test test_construction(ConstantDiscount, exp(complex(0.0, 0.5)))

            # discount returns the correct value
            @test get(ConstantDiscount(0.9), GVFArgs()) == 0.9
            @test get(ConstantDiscount(exp(complex(0.0, 0.5))), GVFArgs()) == exp(complex(0.0, 0.5))
        end
    end

    @testset "Cumulant Tests" begin
        @testset "Feature Cumulant" begin
            # cumulant builds
            @test test_construction(FeatureCumulant, 1)

            # cumulant returns correct value
            @test get(FeatureCumulant(3), GVFArgs([1 2 3])) == 3
        end
    end

    @testset "Policy Tests" begin
        @testset "Null Policy" begin
            # policy builds
            @test test_construction(NullPolicy)

            # policy returns the correct value
            @test get(NullPolicy(), GVFArgs([1,2,3])) == 1.0
        end
    end

    @testset "GVF Tests" begin

        @testset "GVF" begin
            # GVF builds
            @test test_construction(GVF, FeatureCumulant(1), ConstantDiscount(0.9), NullPolicy())

            # GVF returns the right thing
            gvf = GVF(FeatureCumulant(2), ConstantDiscount(0.78), NullPolicy())
            @test all(get(gvf, GVFArgs([1,2,3])) .== [2, 0.78, 1.0])
            @test all(get(gvf, GVFArgs([5,5,5], 1, [1,2,3], 2, [0.1,0.2,0.3])) .== [2, 0.78, 1.0])
        end
    end
end

gvf_tests()
