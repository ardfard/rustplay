use std::sync::{Arc, Mutex};

#[derive(Debug)]
struct Node {
    val: Mutex<i64>,
    adjacent_nodes: Vec<Arc<Node>>,
}

impl Node {
    fn add(&self, val: i64) {
        {
            let mut old_val = self.val.lock().unwrap();
            *old_val = *old_val + val
        }
        for node in self.adjacent_nodes.iter() {
            node.add(val)
        }
    }
}

#[cfg(test)]
mod test_graph {
    use super::Node;
    use std::sync::{Arc, Mutex};

    #[test]
    fn test() {
        let a = Arc::new(Node {
            val: Mutex::new(5),
            adjacent_nodes: vec![],
        });
        let b = Arc::new(Node {
            val: Mutex::new(10),
            adjacent_nodes: vec![a.clone()],
        });

        let b_clone = b.clone();
        let t1 = std::thread::spawn(move || b_clone.add(10));

        t1.join();
        dbg!(b);
    }

    struct A {}

    use std::error::Error;
    impl A {
        pub fn new() -> Self {
            return A {};
        }
        pub fn func_a(self, arg1: String) -> Result<(), Box<dyn Error>> {
            //
            unimplemented!()
        }
        pub fn func_b(self, arg1: String) -> Result<(), Box<dyn Error>> {
            //
            unimplemented!()
        }
    }

    #[test]
    fn test2() {
        let test = "a";
        let struct_a = A::new();
        let func_to_var = |arg| {
            if test == "a" {
                struct_a.func_a(arg)
            } else {
                struct_a.func_b(arg)
            }
        };
    }

    use std::pin::Pin;
    use std::marker::PhantomPinned;
    use std::ptr::NonNull;

    struct Unmovable {
        data: String,
        slice: NonNull<String>,
        _pin: PhantomPinned
    }

    impl Unmovable {
       fn new(data: String) -> Pin<Box<Self>> {
        let res = Unmovable {
            data,
            slice: NonNull::dangling(),
            _pin: PhantomPinned
        };
        let mut boxed = Box::pin(res);
        let slice = NonNull::from(&boxed.data);
        // unsafe {
        //     let mut_ref: Pin<&mut self> = Pin::as_mut(&mut boxed);
        //     Pin::get_unchecked_mut(mut_ref).slice = slice;
        // }
        // boxed
        unimplemented!()
       } 
    }

    #[test]
    fn test3(){
    }

    #[test]
    fn test4(){
        let mut x = 5;
        let y =  &mut x as *mut i32;
        unsafe {
            *y = 1000;
        }

        println!("test {x}");
    }
}
