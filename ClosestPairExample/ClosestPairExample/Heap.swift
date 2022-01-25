//
//  Heap.swift
//  Algorithms
//
//  Created by Shawn Frank on 10/12/2021.
//

import Foundation

/// Defines if the heap is a min heap or a max heap.
/// Also known as the heap invariant.
enum HeapProperty: String
{
    case min = "MIN"
    case max = "MAX"
}

/// Heap sort order
enum HeapSortOrder
{
    case ascending
    case descending
}

/// Swift implementation of a heap
struct Heap<Element: Hashable & Comparable>
{
    /// The array that stores the elements in the heap
    private var elements: [Element] = []
    
    /// A hash map that will store the index of elements in the heap to improve the naive exists function
    /// from O(n) to O(1) in times complexity with some overhead in space
    private var heapHashMap: [Element: Set<Int>] = [:]
    
    /// Compares two elements in the heap based on the heap property
    private var comparator: (Element, Element) -> Bool = (<=)
    
    /// The heap property, also known as the heap invariant which specifies the order / priority in which
    /// elements are organized and stored in the heap
    private lazy var heapProperty: HeapProperty = .min
    {
        // As the heapProperty is set, set how the comparator should compare elements
        didSet
        {
            if heapProperty == .min
            {
                comparator = (<=)
                return
            }
            
            comparator = (>=)
        }
    }
    
    /// Initialize the heap data structure by passing the heap property which defaults to a min heap
    init(withProperty heapProperty: HeapProperty = .min)
    {
        self.heapProperty = heapProperty
    }
    
    /// Parameterized initialize which creates a heap based on the array passed in a process known as 'heapify'
    /// which runs in O(n)
    /// - Parameter withArray: The array to be converted into a heap
    init(withArray array: [Element], andHeapProperty heapProperty: HeapProperty)
    {
        self.heapProperty = heapProperty
        heapify(array)
    }
    
    /// Starting from the leaves of the heap, the function traverses upwards making sure the heap follows
    /// the heap property. Time complexity of this function is O(n)
    /// - Parameter array: The array to be converted into a heap
    mutating
    private func heapify(_ array: [Element])
    {
        elements = array
        
        // loop through all the elements in the array from the end
        for currentIndex in (0 ..< elements.count).reversed()
        {
            // Store the index of the element in the hash map for quick retrieval later
            storeIndexInHashMap(currentIndex)
            
            // Reorder the elements if required to convert the array into a valid heap representation
            sinkIfRequired(currentElementIndex: currentIndex)
        }
    }
    
    /// Maintains a set of indexes for each element in the heap which helps with improving
    /// time to check if an element exists
    /// - Parameter index: Index of the element that needs to be hashed
    mutating
    private func storeIndexInHashMap(_ index: Int)
    {
        let element = elements[index]
        
        // Check if this element exists in the heap
        if var setOfIndexes = heapHashMap[element]
        {
            // Add to the set of indexes already tracked by the hash map
            setOfIndexes.insert(index)
            heapHashMap[element] = setOfIndexes
            return
        }
        
        heapHashMap[element] = [index]
    }
    
    /// Remove the element from the heap and stop tracking it in the hash map
    /// - Parameter index: Index of the element to be discarded
    /// - Returns: The discarded element
    mutating
    private func discardElement(atIndex index: Int) -> Element
    {
        let elementRemoved = elements[index]
        
        elements.remove(at: index)
        
        // Retrieve the set of indexes tracked for this element
        if var elementIndexes = heapHashMap[elementRemoved]
        {
            // Check if this is the only such element being tracked
            if elementIndexes.count == 1
            {
                // Remove the element from being tracked by the hash map
                heapHashMap.removeValue(forKey: elementRemoved)
            }
            else
            {
                // Since there was a duplicate of this element,
                // remove only the index of the current element
                elementIndexes.remove(index)
                heapHashMap[elementRemoved] = elementIndexes
            }
        }
        
        return elementRemoved
    }
    
    /// Moves an element to its correct position in the heap by moving it upwards
    /// - Parameter currentElementIndex: The element that might not be in its right position
    mutating
    private func swimIfRequired(currentElementIndex: Int)
    {
        var currentIndex = currentElementIndex
        
        // Keep looping till the element is in its right position and it is not
        // the root element
        while true && currentIndex > 0
        {
            // Assuming the current element is a left child,
            // retrieve the index of the parent of the current element
            var parentIndex = (currentIndex - 1) / 2
            
            // Handle the case if the current element is the right child
            if currentIndex % 2 == 0
            {
                parentIndex = (currentIndex - 2) / 2
            }
            
            let parentElement = elements[parentIndex]
            let currentElement = elements[currentIndex]
            
            // Check if the current element and the parent needs to swap positions
            // based on the heap property
            if comparator(currentElement, parentElement)
            {
                swapElements(elementOneIndex: currentIndex, elementTwoIndex: parentIndex)
                currentIndex = parentIndex
                continue
            }
            
            return
        }
    }
    
    /// Moves an element to its correct position in the heap by moving it downwards
    /// - Parameter currentElementIndex: The element that might not be in its right position
    mutating
    private func sinkIfRequired(currentElementIndex: Int)
    {
        var currentIndex = currentElementIndex
        
        while true
        {
            // Get the indexes of the current element's children
            let leftChildIndex = currentIndex * 2 + 1
            let rightChildIndex = (currentIndex * 2) + 2
            
            // Skip re-ordering procedures if the current element is a leaf node
            if leftChildIndex >= elements.count
            {
                return
            }
            
            // Assume the left element has a is more significant than the right based on the
            // heap property
            var elementToSwapIndex = leftChildIndex
            var elementToSwap = elements[elementToSwapIndex]
            
            let currentElement = elements[currentIndex]
            
            // Check if there is a valid right child and if the right child is more significant than
            // the left child based on the heap property
            if rightChildIndex < elements.count && comparator(elements[rightChildIndex], elementToSwap)
            {
                elementToSwapIndex = rightChildIndex
                elementToSwap = elements[elementToSwapIndex]
            }
            
            // Check if the more significant child and its parent needs to swap positions
            // based on the heap property
            if comparator(elementToSwap, currentElement)
            {
                // Swap the parent and the more significant child
                swapElements(elementOneIndex: elementToSwapIndex, elementTwoIndex: currentIndex)
                
                // The current element's index is set based on it's new position in the heap
                currentIndex = elementToSwapIndex
                
                continue
            }
            
            return
        }
    }
    
    /// Swaps two elements in the heap and updates the index tracking hash map accordingly
    /// - Parameters:
    ///   - elementOneIndex: Index of the first element to be swapped
    ///   - elementTwoIndex: Index of the second element to be swapped
    mutating
    private func swapElements(elementOneIndex: Int, elementTwoIndex: Int)
    {
        let elementOne = elements[elementOneIndex]
        let elementTwo = elements[elementTwoIndex]
        
        elements[elementOneIndex] = elementTwo
        elements[elementTwoIndex] = elementOne
        
        if var indexesOfElementOne = heapHashMap[elementOne],
           var indexesOfElementTwo = heapHashMap[elementTwo]
        {
            indexesOfElementOne.remove(elementOneIndex)
            indexesOfElementTwo.remove(elementTwoIndex)
            
            indexesOfElementOne.insert(elementTwoIndex)
            indexesOfElementTwo.insert(elementOneIndex)
            
            heapHashMap[elementOne] = indexesOfElementOne
            heapHashMap[elementTwo] = indexesOfElementTwo
        }
    }
    
    // MARK: PUBLIC
    
    /// Performs heap sort on a given array in O(nlog(n))
    /// - Parameters:
    ///   - elements: The array that needs to be sorted
    ///   - sortType: Specifies the order in which the array should be sorted, defaults to ascending.
    static func sort(_ elements: [Element], sortType: HeapSortOrder = .ascending) -> [Element]
    {
        if elements.count <= 1
        {
            return elements
        }
        
        // A min heap is used if an ascending order is desired
        var heapProperty = HeapProperty.min
        
        // A max heap is used if a descending order is desired
        if sortType == .descending
        {
            heapProperty = .max
        }
        
        var sortedArray: [Element] = []
        
        var heap = Heap(withArray: elements, andHeapProperty: heapProperty)
        
        // Keep polling the heap until it becomes empty and the polled elements
        // will be returned in the desired order
        while !heap.isEmpty()
        {
            if let element = heap.poll()
            {
                sortedArray.append(element)
            }
        }
        
        return sortedArray
    }
    
    /// Insert an element into the heap in O(log(n))
    /// - Parameter element: The element to be inserted into the heap
    mutating
    func insert(_ element: Element)
    {
        let indexOfNewElement = elements.count
        
        // Add the new element to the end of the heap
        elements.append(element)
        
        // Start tracking the element's index
        storeIndexInHashMap(indexOfNewElement)
        
        // Since the element was inserted at the end of the heap, it might need
        // to rise to maintain the heap's integrity based on its heap property
        swimIfRequired(currentElementIndex: indexOfNewElement)
    }
    
    /// Remove the root element from the heap in O(log(n))
    /// - Returns: The root element or nil in the event of an empty heap
    mutating
    func poll() -> Element?
    {
        if isEmpty()
        {
            return nil
        }
        
        let rootIndex = 0
        let lastIndex = elements.count - 1
        
        // Swap the root and the last element
        swapElements(elementOneIndex: rootIndex, elementTwoIndex: lastIndex)
        
        // Discard the last element from the heap
        let elementRemoved = discardElement(atIndex: lastIndex)
        
        // Sink the newly created root element as it might need to sink to
        // maintain the heap's integrity based on its heap property
        sinkIfRequired(currentElementIndex: rootIndex)
        
        return elementRemoved
    }
    
    /// Removes an element from the heap in O(log(n))
    /// - Parameter element: element to be removed
    /// - Returns: The element removed from the heap
    mutating
    func remove(_ element: Element) -> Bool
    {
        // Check if the element exists in the heap and retrieves the first index
        // of the element in the heap's array representation
        if let indexesOfElement = heapHashMap[element],
           let firstIndexOfElement = indexesOfElement.first
        {
            let lastIndex = elements.count - 1
            
            // Swap the element to be removed with the last element in the heap
            swapElements(elementOneIndex: lastIndex, elementTwoIndex: firstIndexOfElement)
            
            // The swapped element might need to rise to be in its right position to maintain
            // the heap's integrity
            swimIfRequired(currentElementIndex: firstIndexOfElement)
            
            // If swimming up was not necessary, the node might need to sink to be in its right
            // position to maintain the heap's integrity
            sinkIfRequired(currentElementIndex: firstIndexOfElement)
            
            let _ = discardElement(atIndex: lastIndex)
            
            return true
        }
        
        return false
    }
    
    func isEmpty() -> Bool
    {
        return size() == 0
    }
    
    func size() -> Int
    {
        return elements.count
    }
    
    func peek() -> Element?
    {
        return elements.first
    }
    
    /// Checks if an element exists in the heap in O(1)
    /// - Parameter element: Element to find
    /// - Returns: True if the element exists
    func doesContain(_ element: Element) -> Bool
    {
        return heapHashMap[element] != nil
    }
    
    /// Displays the array representation of the heap
    func displayHeapAsArray()
    {
        print("\n** DISPLAYING HEAP **")
        
        print("[", terminator: "")
        
        for (index, element) in elements.enumerated()
        {
            print("\(element)", terminator: "")
            
            if index < elements.count - 1
            {
                print(", ", terminator: "")
            }
        }
        
        print("]\n")
    }
    
    /// Test method to check the integrity of the min heap
    /// - Parameter index: Specify the node from where you want to start checking, defaults to the root of the heap
    /// - Returns: True if the heap is a valid min binary heap
    func isValidHeap(withRoot index: Int = 0) -> Bool
    {
        // Check if we are outside the boundaries of the heap
        if index >= size()
        {
            return true
        }
        
        // Get the index of the left and right child
        let leftChildIndex = (2 * index) + 1
        let rightChildIndex = (2 * index) + 2
        
        // Check if there is a valid left child and if the left child is NOT in its right position
        // compared to its parent
        if leftChildIndex < size() && !comparator(elements[index], elements[leftChildIndex])
        {
            // Return false since the heap is invalid
            return false
        }
        
        // Perform the same checks on the right side
        if rightChildIndex < size() && !comparator(elements[index], elements[rightChildIndex])
        {
            return false
        }
        
        // Recursively check both the left and right children are valid heaps
        return isValidHeap(withRoot: leftChildIndex) && isValidHeap(withRoot: rightChildIndex)
    }
}
