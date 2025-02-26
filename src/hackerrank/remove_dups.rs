pub fn remove_dups(nums: &mut Vec<i32>) -> i32 {
    let mut unique_idx: Vec<usize> = Vec::with_capacity(nums.len());
    unique_idx.push(0);
    for i  in 1..nums.len() {
        if nums[i-1] != nums[i] {
            unique_idx.push(i);
        } 
    }

    for i in 1..unique_idx.len() {
        nums.swap(i, unique_idx[i]);
    }

    return unique_idx.len() as i32;
}

pub fn move_zeroes(nums: &mut Vec<i32>) -> i32 {
    let mut numZero = 0;
    for i in 0..nums.len() {
        if nums[i] == 0 {
            numZero += 1
        } else {
            nums[i - numZero] = nums[i]
        }
    }
    return numZero as i32
}

pub struct Solution {}

impl Solution {
    // rotate the matrix 90 degrees clockwise
    pub fn rotate(matrix: &mut Vec<Vec<i32>>) {
        let n = matrix.len();
        // Step 1: Transpose the matrix
        for i in 0..n {
            for j in 0..i {
                let temp = matrix[i][j];
                matrix[i][j] = matrix[j][i];
                matrix[j][i] = temp;
            }
        }
        
        // Step 2: Reverse each row
        for row in matrix.iter_mut() {
            row.reverse();
        }
    }
}