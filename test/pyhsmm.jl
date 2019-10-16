using Test
using Random
using PyCall
using HMMBase

pyhsmm = pyimport("pyhsmm")

Random.seed!(42)

trans_matrix = rand(10,10)
trans_matrix = trans_matrix ./ sum(trans_matrix, dims=2)
init_distn = ones(10) / 10
log_likelihoods = log.(rand(2500,10))

@testset "Scaled" begin
    ref = pyhsmm.internals.hmm_states.HMMStatesPython._messages_forwards_normalized(trans_matrix, init_distn, log_likelihoods)
    res = forwardlog(init_distn, trans_matrix, log_likelihoods)

    @test sum(abs.(ref[1]-res[1])) < 1e-11
    @test sum(abs.(ref[2]-res[2])) < 1e-11

    ref = pyhsmm.internals.hmm_states.HMMStatesPython._messages_backwards_normalized(trans_matrix, init_distn, log_likelihoods)
    res = backwardlog(init_distn, trans_matrix, log_likelihoods)

    @test sum(abs.(ref[1]-res[1])) < 1e-11
    @test sum(abs.(ref[2]-res[2])) < 1e-11
end
