fn diagonal_difference(arr: &[Vec<i32>]) -> i32 {
    let mut left_to_right = 0;
    let mut right_to_left = 0;

    for i in 0..arr.len() {
        left_to_right += arr[i][i];
        right_to_left += arr[i][arr.len() - 1 - i];
    }

    (left_to_right - right_to_left).abs()
}

#[cfg(test)]
mod diagonal_difference_test {
    use super::diagonal_difference;

    #[test]
    fn test_diagonal_difference() {
        let arr = vec![vec![1, 2, 3], vec![4, 5, 6], vec![9, 8, 9]];
        let result = diagonal_difference(&arr);
        assert_eq!(result, 2);
    }
}