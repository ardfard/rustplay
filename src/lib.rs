mod graph;
mod smart_ptr;
mod hackerrank;

// Add test
#[cfg(test)]
mod tests {
    use std::{
        fs::File, io::{self, Read}, ops::Deref, path::{Display, Path}
    };

    // This is an example of using AsRef. Note AsRef<T> means that the type can
    // be converted to a reference of type T.
    #[test]
    fn as_ref_test() {
        fn cat<T: AsRef<Path>>(path: T) {
            println!("the path: {:?}", path.as_ref());
            // open file at path
            let mut file = File::open(path).unwrap();

            // print the file content as string
            let mut content = String::new();

            file.read_to_string(&mut content)
                .expect("failed to read file");

            println!("the content: {}", content);
        }

        // using &str
        cat(".envrc");

        // using Path
        cat(Path::new(".envrc"));

        // using PathBuf
        cat(Path::new(".").join(".envrc"));

        // using String
        cat(String::from("./.envrc"));
    }

    struct Data {
        internal: [u8; 4],
    }
    struct Widget(Option<Data>);

    impl Data {
        pub fn crunch(&self) -> i32 {
            let mut sum: i32 = 0;
            for byte in &self.internal {
                sum += *byte as i32;
            }
            sum
        }
    }

    impl Widget {
        fn get_data(&self) -> Option<&Data> {
            self.0.as_ref()
        }
    }

    #[test]
    fn option_test() {
        let w = Widget(Some(Data {
            internal: [1, 2, 3, 4],
        }));
        let o = Some(20);
    }

    trait Speak {
        fn speak(&self);
    }

    struct Dog;

    impl Speak for Dog {
        fn speak(&self) {
            println!("woof!")
        }
    }

    struct Trainer<'a, T: Speak> {
        animal: &'a T,
    }

    impl<'a, T: Speak> Trainer<'a, T> {
        fn training(&self) {
            println!("start training...");
            self.animal.speak();
            self.animal.speak();
        }
    }
    /// Helper module allowing to specify concrete types in bounds
    pub mod type_bound {
        mod sealed {
            pub trait IsType<T: ?Sized> {}
            impl<T: ?Sized> IsType<T> for T {}
        }

        /// Trait `IsType<T>` is implemented if and only if `Self` is `T`
        pub trait IsType<T: ?Sized>: sealed::IsType<T> {
            /// Convert from `T` to `Self` (no-op)
            fn identity_from(x: T) -> Self
            where
                Self: Sized;
            /// Convert from `Self` to `T` (no-op)
            fn identity_into(self) -> T
            where
                Self: Sized;
        }

        impl<T: ?Sized> IsType<T> for T {
            fn identity_from(x: T) -> Self
            where
                Self: Sized,
            {
                x
            }
            fn identity_into(self) -> T
            where
                Self: Sized,
            {
                self
            }
        }
    }

    pub use type_bound::IsType;
    trait Functor: Sized + IsType<Self::Wrapped<Self::Unwrapped>> {
        /// Same wrapper, but different inner type
        type Wrapped<Unwrapped>: Functor;
        /// Inner type
        type Unwrapped;

        /// Replaces inner type and value by applying a mapping function
        fn map<B, F>(self, f: F) -> Self::Wrapped<B>
        where
            F: FnMut(Self::Unwrapped) -> B;
    }

    impl<A> Functor for Option<A> {
        type Wrapped<B> = Option<B>;
        type Unwrapped = A;

        fn map<B, F>(self, mut f: F) -> Self::Wrapped<B>
        where
            F: FnMut(Self::Unwrapped) -> B,
        {
            match self {
                Some(value) => Some(f(value)),
                None => None,
            }
        }
    }

    fn convert_inner<T, B>(wrapped: T) -> T::Wrapped<B>
    where
        T: Functor,
        T::Unwrapped: Into<B>,
    {
        wrapped.map(Into::into)
    }

    trait Semigroup {
        fn append(self, other: Self) -> Self;
    }

    impl Semigroup for String {
        fn append(self, other: Self) -> Self {
            self + &other
        }
    }

    struct A;

    impl std::fmt::Display for A {
        fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
            write!(f, "A")
        }
    }
    struct B;

    impl std::fmt::Display for B {
        fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
            write!(f, "B")
        }
    }

    trait Ngedisplay<T> {
        fn ngedisplay(&self);
    }

    static mut x: &str = "taimu";
    impl<T, U> Ngedisplay<T> for U
    where
        U: std::fmt::Display,
    {
        fn ngedisplay(&self) {
            let s = String::from("Hello");
            let t = s.deref();
            let i = "tai";
            println!("{}", self);
        }
    }

    #[test]
    fn testing() {
        let b = B;
        let c = Box::new("testing");
        let y : [char; 8] = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
        <_ as Ngedisplay<i32>>::ngedisplay(&b);
    }

    pub trait Deserialize<'de>: Sized {
        type Error;

        fn deserialize_any<V>(self, visitor: V) -> Result<V::Value, Self::Error>
        where
            V: Visitor<'de>;
    }

    use std::error::Error;

    pub trait Visitor<'de>: Sized {
        type Value;

        fn visit_bool<E>(self, v: bool) -> Result<Self::Value, E>
        where
            E: Error;

        fn visit_u64<E>(self, v: u64) -> Result<Self::Value, E>
        where
            E: Error;

        fn visit_str<E>(self, v: &str) -> Result<Self::Value, E>
        where
            E: Error;
    }


    #[test]
    fn test(){
        println!("{}", 5 & 7);
        
    }

    pub fn min_end(n: i32, y: i32) -> i64 {
        let mut m = n;
        let mut res = y;
        for i in 0..32 {
            if m == 1 {
                break;
            }
            if (2 << i) > res {
                res = res + (2 << i);
                m = m - 1;
            }
            
        }
        res as i64
    }

    fn int_to_bin(n : i32) -> [i8;32] {
        let mut res : [i8; 32] = [0; 32];
        let mut i = 31;
        let mut y = n;
        while y > 0 {
            res[i] = (y % 2) as i8;
            y = y / 2;
            i -= 1;
        }
        res
    }
}
