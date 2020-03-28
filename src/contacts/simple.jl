struct SimpleRepulsionModel12<:RepulsionModel12
    pair::Array{Int64,1}
    densities::Array{Float64,1}
    alpha::Float64
    epsilon::Float64
    equi_dist::Float64
    neighs::Array{Int64,2}
    distance::Float64
    max_neighs::Int64
end

struct SimpleRepulsionModel11<:RepulsionModel11
    type::Int64
    material::GeneralMaterial
    alpha::Float64
    epsilon::Float64
    neighs::Array{Int64,2}
    distance::Float64
    max_neighs::Int64
end


function SimpleRepulsionModel(alpha::Float64,epsilon::Float64, mat1::PeridynamicsMaterial,mat2::PeridynamicsMaterial;distanceX=5,max_neighs=50)
    p_size = (mat1.general.particle_size+mat2.general.particle_size)/2
    neighs = zeros(min(max_neighs,size(mat2.general.x,2)), size(mat1.general.x,2))
    SimpleRepulsionModel12([mat1.type,mat2.type],[mat1.general.density,mat2.general.density],alpha,epsilon,p_size,neighs,p_size*distanceX,min(max_neighs,size(mat2.general.x,2)))
end


function SimpleRepulsionModel(alpha::Float64,epsilon::Float64, mat1::PeridynamicsMaterial;distanceX=5,max_neighs=50)
    max_neighs = min(max_neighs,size(mat1.general.x,2))
    neighs = zeros(max_neighs, size(mat1.general.x,2))
    SimpleRepulsionModel11(mat1.type,mat1.general,alpha,epsilon,neighs, mat1.general.particle_size*distanceX,max_neighs)
end


function repulsion_acc(dr,den_i,RepMod::SimpleRepulsionModel12)
    del_x = RepMod.equi_dist - s_magnitude(dr)
    if del_x<0
        return zeros(size(dr)...)
    else
        return -(RepMod.epsilon*del_x^(RepMod.alpha-1)).*dr/s_magnitude(dr)/RepMod.densities[den_i]
    end
end

function repulsion_acc(dr,RepMod::SimpleRepulsionModel11)
    del_x = -1+RepMod.material.particle_size/s_magnitude(dr)
    if del_x<0
        return zeros(size(dr)...)
    else
        return -(RepMod.epsilon*del_x^(RepMod.alpha-1)).*dr/s_magnitude(dr)/RepMod.material.density
    end
end