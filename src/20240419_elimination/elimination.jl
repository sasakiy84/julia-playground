function exchangeRows(𝔸::Matrix, i, j)
    tempRow = 𝔸[i, :]
    𝔸[i, :] = 𝔸[j, :]
    𝔸[j, :] = tempRow
    return 𝔸
end

function subtractPivotRow(𝔸::Matrix, targetRowNum, pivotRowNum)
    pivot = 𝔸[pivotRowNum, pivotRowNum]
    numBelowPivot = 𝔸[targetRowNum, pivotRowNum]
    multipliedPivotRow = 𝔸[pivotRowNum, :] * (numBelowPivot / pivot)
    𝔸[targetRowNum, :] = 𝔸[targetRowNum, :] - multipliedPivotRow
    return 𝔸
end

function doForwardElimination(𝔸::Matrix)::Matrix
    # because division is used
    𝔸 = float(𝔸)

    # n equations and n unknowns matrix, or augmented matrix are allowed 
    rowNum, colNum = size(𝔸)
    if rowNum > colNum
        throw(DomainError(𝔸, "rowNum must be less or equal than colNum, but got $(rowNum) by $(colNum)"))
    end

    for pivotRowNum in 1:rowNum

        # looking for pivot with permutation
        pivotCanditate = 𝔸[pivotRowNum, pivotRowNum]
        for permutationRowNum in pivotRowNum+1:rowNum
            if pivotCanditate != 0
                # pivot value found!
                break
            end

            exchangeRows(𝔸, pivotRowNum, permutationRowNum)
            pivotCanditate = 𝔸[pivotRowNum, pivotRowNum]
        end

        if pivotCanditate == 0
            throw(ErrorException("$(pivotRowNum)th pivot does not exist"))
        end

        # knock out coefficient below pivot
        for targetRowNum in pivotRowNum+1:rowNum
            subtractPivotRow(𝔸, targetRowNum, pivotRowNum)
        end
    end

    return 𝔸
end

𝔸 = [1 2 1;
    3 8 1;
    0 4 1]

𝕌 = [1 2 1;
    0 2 -2
    0 0 5]

@assert doForwardElimination(𝔸) == 𝕌

AugmentedMatrix = [1 2 1 2;
    3 8 1 12;
    0 4 1 2]

eliminatedAugmentedMatrix = [1.0 2.0 1.0 2.0;
    0.0 2.0 -2.0 6.0;
    0.0 0.0 5.0 -10.0]


@assert doForwardElimination(AugmentedMatrix) == eliminatedAugmentedMatrix

