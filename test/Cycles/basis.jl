@testset "Cycle Basis" begin

    function evaluate(x,y)
        x_sorted = sort(sort.(x))
        y_sorted = sort(sort.(y))
        @test x_sorted == y_sorted
    end

    # No Edges
    ex = SimpleGraph(1)
    expected_cyclebasis = Array{Int64,1}[]
    @testset "no edges $g" for g in testgraphs(ex)
        ex_cyclebasis = @inferred LCY.cycle_basis(g)
        @test isempty(ex_cyclebasis)
    end

    # Only one self-edge
    elist = [(1,1)]
    ex = SimpleGraph(SimpleEdge.(elist))
    expected_cyclebasis = Array{Int64,1}[[1]]
    @testset "one self-edge $g" for g in testgraphs(ex)
        ex_cyclebasis = LCY.cycle_basis(g)
        evaluate(ex_cyclebasis, expected_cyclebasis)
    end

    # SimpleGraph with one cycle
    elist = [(1,2),(2,3),(3,4),(4,1),(1,5)]
    ex = SimpleGraph(SimpleEdge.(elist))
    expected_cyclebasis = Array{Int64,1}[
        [1,2,3,4] ]
    @testset "one cycle $g" for g in testgraphs(ex)
        ex_cyclebasis = LCY.cycle_basis(g)
        evaluate(ex_cyclebasis, expected_cyclebasis)
    end

    # SimpleGraph with 2 of 3 cycles forming a basis
    elist = [(1,2),(1,3),(2,3),(2,4),(3,4)]
    ex = SimpleGraph(SimpleEdge.(elist))
    expected_cyclebasis = Array{Int64,1}[
        [2,3,4],
        [2,1,3] ]
    @testset "2 of 3 cycles w/ basis $g" for g in testgraphs(ex)
        ex_cyclebasis = LCY.cycle_basis(g)
        evaluate(ex_cyclebasis, expected_cyclebasis)
    end

    # Testing root argument
    elist = [(1,2),(1,3),(2,3),(2,4),(3,4),(1,5),(5,6),(6,4)]
    ex = SimpleGraph(SimpleEdge.(elist))
    expected_cyclebasis = Array{Int64,1}[
        [2, 4, 3],
        [1, 5, 6, 4, 3],
        [1, 2, 3] ]
    @testset "root argument $g" for g in testgraphs(ex)
        ex_cyclebasis = @inferred LCY.cycle_basis(g,3)
        evaluate(ex_cyclebasis, expected_cyclebasis)
    end

    @testset "two isolated cycles" begin
        cg3 = SimpleGraph(SGGEN.Cycle(3))
        cg4 = SimpleGraph(SGGEN.Cycle(4))
        ex = blockdiag(cg3, cg4)
        expected_cyclebasis = [[1, 2, 3], [4, 5, 6, 7]]
        @testset "$g" for g in testgraphs(ex)
            found_cyclebasis = @inferred LCY.cycle_basis(g)
            evaluate(expected_cyclebasis, found_cyclebasis)
        end
    end
end
