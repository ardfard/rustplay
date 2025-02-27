use std::{cell::RefCell, rc::{Rc, Weak}};

type NodeRef<V> = Rc<RefCell<Node<V>>>;
type ParentNodeRef<V> = Weak<RefCell<Node<V>>>;

struct Node<V: std::cmp::PartialOrd> {
    value: V,
    parent: Option<ParentNodeRef<V>>,
    left: Option<NodeRef<V>>,
    right: Option<NodeRef<V>>,
}

impl<V: std::cmp::PartialOrd> Node<V> {
    fn new(
        value: V,
        parent: Option<ParentNodeRef<V>>,
        left: Option<NodeRef<V>>,
        right: Option<NodeRef<V>>,
    ) -> Self {
        Node {
            value,
            parent,
            left,
            right,
        }
    }
}



struct BinaryTree<V: std::cmp::PartialOrd> {
    root: Option<NodeRef<V>>,
}

fn insert_node<V: std::cmp::PartialOrd>(value: V, node: NodeRef<V>) {
    if node.borrow().value > value {
        if let Some(ref right) = node.borrow().right {
            insert_node(value, right.clone());
        } else {
            let new_node = Node::new(value, Some(Rc::downgrade(&node)), None, None);
            node.borrow_mut().right = Some(Rc::new(RefCell::new(new_node)));
        }
    } else {
        if let Some(ref left) = node.borrow().left {
            insert_node(value, left.clone());
        } else {
            let new_node = Node::new(value, Some(Rc::downgrade(&node)), None, None);
            node.borrow_mut().left = Some(Rc::new(RefCell::new(new_node)));
        }
    }
}


fn delete_node<V: std::cmp::PartialOrd>(value: V, node: NodeRef<V>) {
    if node.borrow().value > value {
        if let Some(ref right) = node.borrow().right {
            if right.borrow().value == value {
                let child_right = right.borrow().right.clone();
                let child_left = right.borrow().left.clone();

            } else {
                delete_node(value, right.clone());
            }
        }
    }
}

impl<V: std::cmp::PartialOrd> BinaryTree<V> {
    fn new() -> Self {
        BinaryTree { root: None }
    }

    fn insert(&mut self, value: V) {
        match self.root {
            None => {
                let new_node = Node::new(value, None, None, None);
                self.root = Some(Rc::new(RefCell::new(new_node)));
            },
            Some(ref node) => {
                insert_node(value, node.clone());
            }
        }
    }

    fn delete(&mut self, value: V) {
        if let Some(ref root) = self.root {
            if root.borrow().value == value {
                self.root = None;
            } else {
                delete_node(value, root.clone());
            }
        }
    }
}

#[cfg(test)]
mod test {

    use super::*;  
    #[test]
    fn test() {
    }
}