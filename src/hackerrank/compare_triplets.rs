fn compare_triplets(a: &[i32], b: &[i32]) -> Vec<i32> {
    let mut alice_score = 0;
    let mut bob_score = 0;

    for i in 0..a.len() {
        if a[i] > b[i] {
            alice_score += 1;
        } else if a[i] < b[i] {
            bob_score += 1;
        }
    }

    vec![alice_score, bob_score]
}

#[cfg(test)]
mod compare_triplets_test {

    use std::io::{self, BufRead, Write};

    use super::compare_triplets;

    #[test]
    fn test_compare_triplets() {
        let a = vec![5, 6, 7];
        let b = vec![3, 6, 10];
        let result = compare_triplets(&a, &b);

        for i in 0..result.len() {
            print!("{}", result[i]);
            print!{" "};
        }
    }
}
