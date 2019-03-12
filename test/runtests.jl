
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
    @testset "GVF Tests" begin
        @testset "GVF" begin
            @test test_construction(GVF, FeatureCumulant(1), ConstantDiscount(0.9), NullPolicy())

            gvf = GVF(FeatureCumulant(2), ConstantDiscount(0.78), NullPolicy())
            @test all(get(gvf, [5,5,5], 1, [1,2,3]) .== [2, 0.78, 1.0])
            @test all(get(gvf, [5,5,5], 1, [1,2,3], [0.1, 0.2, 0.3]) .== [2, 0.78, 1.0])
            @test all(get(gvf, [5,5,5], 1, [1,2,3], 2, [0.1,0.2,0.3]) .== [2, 0.78, 1.0])
        end
    end
end

gvf_tests()
