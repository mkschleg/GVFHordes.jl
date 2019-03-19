
using Test
using Horde
using Flux
# using BenchmarkTools

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
        # Previous implementation.
        
    end
end

function horde_tests()
    @testset "Horde Tests" begin
        @testset "GVFHorde" begin
            @test test_construction(GVFHorde,
                                    [GVF(FeatureCumulant(1), ConstantDiscount(0.9), NullPolicy()),
                                     GVF(FeatureCumulant(2), ConstantDiscount(0.8), NullPolicy())], Flux.Dense(1,2))

            gvfc = GVFHorde([GVF(FeatureCumulant(1), ConstantDiscount(0.9), NullPolicy()),
                             GVF(FeatureCumulant(2), ConstantDiscount(0.8), NullPolicy())], Flux.Dense(1,2))
            @test all(get(gvfc, [5,5,5], 1, [1,2,3], nothing, nothing) .== [[1,2],[0.9, 0.8], [1.0, 1.0]])
        end
    end

end

@testset "Horde.jl Tests:" begin
    gvf_tests()
    horde_tests()
end
