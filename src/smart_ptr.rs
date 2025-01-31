#[cfg(test)]
mod tests_smt_ptr {
    use std::{cell::RefCell, ops::Deref, rc::Rc};

    // box is to allocate data in the heap
    #[test]
    fn boxes() {
        // This allocate an 32 byte in the heap and store the value 5
        let mut v = Box::new(5);

        // it the modify the value in the memory by adding 1
        *v = *v + 1;
        println!("{:p}", &*v as *const _)
    }

    // rc is reference counted smart pointer container
    #[test]
    fn rc() {
        // create new Rc
        let v = Rc::new(5);

        // Let's find out the address
        println!("{:p}", &*v);
        {
            // Create new reference
            let w = v.clone();
            // Let's print the address. Should be the same
            println!("{:p}", &*w);
            println!("{}", w)
        }

        // Following will error because Rc doesn't permit mutability
        // let mut w = v.clone();
        // *w = *w + 1

        // let's say i want a mutable Rc, let's use a Refcell.
        let x = Rc::new(RefCell::new(5));
        {
            let y = x.clone();
            let mut z = y.borrow_mut();
            *z = *z + 1;

            // below will panic
        }
        println!("{}", x.borrow());
        let t: &RefCell<i32> = x.as_ref();
        let u = x.borrow();
        println!("{}", t.borrow());
    }

    #[test]
    fn refcell() {}

    #[test]
    fn fstest() {
        let mut x: i32 = 2147483647;
        x = x + 1;
        println!("{}", x)
    }
}

