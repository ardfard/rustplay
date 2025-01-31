
fn a_very_big_sum(ar: &[i64]) -> i64 {
    ar.iter().fold(0, |acc, x| acc + x)
}

#[cfg(test)]
mod a_very_big_sum_test {
    use super::a_very_big_sum;


    #[test]
    fn test_a_very_big_sum() {
        let ar = vec![1000000001, 1000000002, 1000000003, 1000000004, 1000000005];
        let result = a_very_big_sum(&ar);
        assert_eq!(result, 5000000015);
    }
}
