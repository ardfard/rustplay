use std::cell::RefCell;
use std::collections::HashMap;
use std::hash::Hash;
use std::rc::Rc;
use std::borrow::ToOwned;


#[derive(Clone)]
struct Node<V> {
    value: V, 
    previous: Option<Rc<RefCell<Node<V>>>>,
    next: Option<Rc<RefCell<Node<V>>>>,
}

impl<V> Node<V> {
    fn new(value: V) -> Self {
        Node {
            value,
            previous: None,
            next: None,
        }
    }

    fn delete(&mut self) {
        if let Some(prev) = &self.previous {
            prev.borrow_mut().next = self.next.clone();
        }
        if let Some(next) = &self.next {
            next.borrow_mut().previous = self.previous.clone();
        }
    }
}

struct DoubleLinkedList<V> {
    head: Option<Rc<RefCell<Node<V>>>>,
    tail: Option<Rc<RefCell<Node<V>>>>
}

impl<V> DoubleLinkedList<V> {
    fn new() -> Self {
        DoubleLinkedList { head: None, tail: None }
    }

    fn add(&mut self, val: V) -> Rc<RefCell<Node<V>>> {
        let node = Rc::new(RefCell::new(Node::new(val)));
        
        match &self.head {
            None => {
                self.head = Some(node.clone());
                self.tail = Some(node.clone());
            }
            Some(old_head) => {
                node.borrow_mut().next = Some(old_head.clone());
                old_head.borrow_mut().previous = Some(node.clone());
                self.head = Some(node.clone());
            }
        }
        node
    }

    fn remove(&mut self, node: Rc<RefCell<Node<V>>>) {
        if let Some(head) = &self.head {
            if Rc::ptr_eq(head, &node) {
                self.head = node.borrow().next.clone();
            }
        }

        if let Some(tail) = &self.tail {
            if Rc::ptr_eq(tail, &node) {
                self.tail = node.borrow().previous.clone();
            }
        }

        node.borrow_mut().delete();
    }

    fn len(&self) -> usize {
        let mut count = 0;
        let mut current = self.head.clone();
        while let Some(node) = current {
            count += 1;
            current = node.borrow().next.clone();
        }
        count
    }
}


struct LRUCache<K: Eq + Hash, V: Clone> {
    capacity: usize,
    cache: HashMap<K, (V, Rc<RefCell<Node<K>>>)>,
    order: DoubleLinkedList<K>
}

impl<K: Eq + Hash + Clone, V: Clone> LRUCache<K,V> {
    fn new(capacity: usize) -> Self {
        LRUCache { 
            capacity, 
            cache: HashMap::with_capacity(capacity),
            order: DoubleLinkedList::new() 
        }
    }

    fn get(&mut self, key: &K) -> Option<V> {
        if let Some((value, node)) = self.cache.get(key) {
            let v = value.clone();
            self.order.remove(node.clone());
            let new_node = self.order.add(key.clone());
            self.cache.get_mut(key).unwrap().1 = new_node;
            Some(v)
        } else {
            None
        }
    }

    fn put(&mut self, key: K, value: V) {
        if let Some((_, node)) = self.cache.remove(&key) {
            self.order.remove(node);
        } else if self.cache.len() == self.capacity {
            if let Some(tail) = self.order.tail.clone() {
                let old_key = tail.borrow().value.clone();
                self.cache.remove(&old_key);
                self.order.remove(tail);
            }
        }
        
        let node = self.order.add(key.clone());
        self.cache.insert(key, (value, node));
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_lru_cache() {
        let mut cache = LRUCache::new(2);
        
        // Test basic put and get
        cache.put("one".to_string(), 1);
        cache.put("two".to_string(), 2);
        assert_eq!(cache.get(&"one".to_string()), Some(1));
        assert_eq!(cache.get(&"two".to_string()), Some(2));
        
        // Test capacity limit
        cache.put("three".to_string(), 3);  // This should evict "one"
        assert_eq!(cache.get(&"one".to_string()), None);
        assert_eq!(cache.get(&"two".to_string()), Some(2));
        assert_eq!(cache.get(&"three".to_string()), Some(3));
        
        // Test updating existing key
        cache.put("two".to_string(), 22);
        assert_eq!(cache.get(&"two".to_string()), Some(22));
        
        // Test LRU eviction order
        cache.get(&"three".to_string());  // This moves 3 to front
        cache.put("four".to_string(), 4);  // This should evict "two"
        assert_eq!(cache.get(&"two".to_string()), None);
        assert_eq!(cache.get(&"three".to_string()), Some(3));
        assert_eq!(cache.get(&"four".to_string()), Some(4));
    }
}
