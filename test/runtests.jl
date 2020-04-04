using PeriDyn, Test
const PD = PeriDyn

x0 = PD.create_block([1.0,1,1],[2,2,2])
v0 = x0*0
gen_mat = PD.GeneralMaterial(x0,v0,x0,x0[1,:]*0 .+ 1, 1000.0, 3.0, 0.5)

@testset "util.jl" begin

    # horizon correction
    @test isapprox(PD.horizon_correction(1,1,1),1)

    # influence function
    @test isapprox(PD.influence_function([1.0,0,0]),1/1.0)
    @test isapprox(PD.influence_function([2.0,0,0]),1/2.0)
    @test isapprox(PD.influence_function([4.0,3.0,0]),1/5.0)
    @test isapprox(PD.influence_function([1.0,3.0,4.0]),1/sqrt(26.0))

    # weighted volume
    @test isapprox(sum(PD.weighted_volume(gen_mat)),8*8.974691494688162;atol = 1.0e-6)
    @test isapprox(sum(PD.weighted_volume(gen_mat)),8*8.974691494688162)

    # dilatation
    @test isapprox(sum(PD.dilatation_theta(1x0,gen_mat)),0.0)
    @test isapprox(sum(PD.dilatation_theta(1.1x0,gen_mat)), 8*(3*0.1+3*0.1*sqrt(2)+0.1*sqrt(3)))

    x2 = 1x0
    x2[2,:] .*= 1.1
    @test isapprox(sum(PD.dilatation_theta(x2,gen_mat)), 8*(0.1 + 2*(sqrt(1+1.1^2)-sqrt(2)) + (sqrt(2+1.1^2)-sqrt(3)) ))

    x2 = 1x0
    x2[1,:] .*= 1.1
    @test isapprox(sum(PD.dilatation_theta(x2,gen_mat)), 8*(0.1 + 2*(sqrt(1+1.1^2)-sqrt(2)) + (sqrt(2+1.1^2)-sqrt(3)) ))
end



#
