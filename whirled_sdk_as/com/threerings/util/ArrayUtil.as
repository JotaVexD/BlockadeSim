//
// $Id: ArrayUtil.as 103 2009-09-11 22:58:43Z ray $
//
// Flash Utils library - general purpose ActionScript utility code
// Copyright (C) 2007-2009 Three Rings Design, Inc., All Rights Reserved
// http://www.threerings.net/code/ooolib/
//
// This library is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as published
// by the Free Software Foundation; either version 2.1 of the License, or
// (at your option) any later version.
//
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

package com.threerings.util {

/**
 * Contains methods that should be in Array, but aren't. Additionally
 * contains methods that understand the interfaces in this package.
 * So, for example, removeFirst() understands Equalable and will remove
 * an element that is equals() to the specified element, rather than just
 * === (strictly equals) to the specified element.
 */
public class ArrayUtil
{
    /**
     * Creates a new Array and fills it with a default value.
     * @param size the size of the array
     * @param val the value to store at each index of the Array
     */
    public static function create (size :uint, val :* = null) :Array
    {
        var arr :Array = new Array(size);
        for (var ii :uint = 0; ii < size; ii++) {
            arr[ii] = val;
        }

        return arr;
    }

    /**
     * Creates a shallow copy of the array.
     *
     * @internal TODO: add support for copy ranges and deep copies?
     */
    public static function copyOf (arr :Array) :Array
    {
        return arr.slice();
    }

    /**
     * Sort the specified array according to natural order- all elements
     * must implement Comparable or be null.
     */
    public static function sort (arr :Array) :void
    {
        arr.sort(Comparators.compareComparables);
    }

    /**
     * Sort the specified array according to one or more fields of the objects in the Array.
     *
     * Array.sortOn() only works with public variables, and not with public getters.
     * This implementation works with both.
     *
     * @param sortFields an Array of Strings, representing the order of fields to sort the array by
     */
    public static function sortOn (arr :Array, sortFields :Array) :void
    {
        stableSort(arr, Comparators.createFields(sortFields));
    }

    /**
     * Perform a stable sort on the specified array.
     * @param comp a function that takes two objects in the array and returns -1 if the first
     * object should appear before the second in the container, 1 if it should appear after,
     * and 0 if the order does not matter. If omitted, Comparators.compareComparables is used and
     * the array elements should be Comparable objects.
     */
    public static function stableSort (arr :Array, comp :Function = null) :void
    {
        if (comp == null) {
            comp = Comparators.compareComparables;
        }
        // insertion sort implementation
        var nn :int = arr.length;
        for (var ii :int = 1; ii < nn; ii++) {
            var val :* = arr[ii];
            var jj :int = ii - 1;
            for (; jj >= 0; jj--) {
                var compVal :* = arr[jj];
                if (comp(val, compVal) >= 0) {
                    break;
                }
                arr[jj + 1] = compVal;
            }
            arr[jj + 1] = val;
        }
    }

    /**
     * Inserts an object into a sorted Array in its correct, sorted location.
     *
     * @param comp a function that takes two objects in the array and returns -1 if the first
     * object should appear before the second in the container, 1 if it should appear after,
     * and 0 if the order does not matter. If omitted, Comparators.compareComparables is used and
     * the array elements should be Comparable objects.
     *
     * @return the index of the inserted item
     */
    public static function sortedInsert (arr :Array, val :*, comp :Function = null) :int
    {
        if (comp == null) {
            comp = Comparators.compareComparables;
        }

        var insertedIdx :int = -1;
        var nn :int = arr.length;
        for (var ii :int = 0; ii < nn; ii++) {
            var compVal :* = arr[ii];
            if (comp(val, compVal) <= 0) {
                arr.splice(ii, 0, val);
                insertedIdx = ii;
                break;
            }
        }

        if (insertedIdx < 0) {
            arr.push(val);
            insertedIdx = arr.length - 1;
        }

        return insertedIdx;
    }

    /**
     * Randomly shuffle the elements in the specified array.
     *
     * @param rando a random number generator to use, or null if you don't care.
     */
    public static function shuffle (arr :Array, rando :Random = null) :void
    {
        var randFunc :Function = (rando != null) ? rando.nextInt :
            function (n :int) :int {
                return int(Math.random() * n);
            };
        // starting from the end of the list, repeatedly swap the element in
        // question with a random element previous to it up to and including
        // itself
        for (var ii :int = arr.length - 1; ii > 0; ii--) {
            var idx :int = randFunc(ii + 1);
            var tmp :Object = arr[idx];
            arr[idx] = arr[ii];
            arr[ii] = tmp;
        }
    }

    /**
     * Returns the index of the first item in the array for which the predicate function
     * returns true, or -1 if no such item was found. The predicate function should be of type:
     *   function (element :*) :Boolean { }
     *
     * @return the zero-based index of the matching element, or -1 if none found.
     */
    public static function indexIf (arr :Array, predicate :Function) :int
    {
        if (arr != null) {
            for (var ii :int = 0; ii < arr.length; ii++) {
                if (predicate(arr[ii])) {
                    return ii;
                }
            }
        }
        return -1; // never found
    }

    /**
     * Returns the first item in the array for which the predicate function returns true, or
     * undefined if no such item was found. The predicate function should be of type:
     *   function (element :*) :Boolean { }
     *
     * @return the matching element, or undefined if no matching element was found.
     */
    public static function findIf (arr :Array, predicate :Function) :*
    {
        var index :int = (arr != null ? indexIf(arr, predicate) : -1);
        return (index >= 0 ? arr[index] : undefined);
    }

    /**
     * Returns the first index of the supplied element in the array. Note that if the element
     * implements Equalable, an element that is equals() will have its index returned, instead
     * of requiring the search element to be === (strictly equal) to an element in the array
     * like Array.indexOf().
     *
     * @return the zero-based index of the matching element, or -1 if none found.
     */
    public static function indexOf (arr :Array, element :Object) :int
    {
        if (arr != null) {
            for (var ii :int = 0; ii < arr.length; ii++) {
                if (Util.equals(arr[ii], element)) {
                    return ii;
                }
            }
        }
        return -1; // never found
    }

    /**
     * @return true if the specified element, or one that is Equalable.equals() to it, is
     * contained in the array.
     */
    public static function contains (arr :Array, element :Object) :Boolean
    {
        return (indexOf(arr, element) != -1);
    }

    /**
     * Remove the first instance of the specified element from the array.
     *
     * @return true if an element was removed, false otherwise.
     */
    public static function removeFirst (arr :Array, element :Object) :Boolean
    {
        return removeImpl(arr, element, true);
    }

    /**
     * Remove the last instance of the specified element from the array.
     *
     * @return true if an element was removed, false otherwise.
     */
    public static function removeLast (arr :Array, element :Object) :Boolean
    {
        arr.reverse();
        var removed :Boolean = removeFirst(arr, element);
        arr.reverse();
        return removed;
    }

    /**
     * Removes all instances of the specified element from the array.
     *
     * @return true if at least one element was removed, false otherwise.
     */
    public static function removeAll (arr :Array, element :Object) :Boolean
    {
        return removeImpl(arr, element, false);
    }

    /**
     * Removes the first element in the array for which the specified predicate returns true.
     *
     * @param pred a Function of the form: function (element :*) :Boolean
     *
     * @return true if an element was removed, false otherwise.
     */
    public static function removeFirstIf (arr :Array, pred :Function) :Boolean
    {
        return removeIfImpl(arr, pred, true);
    }

    /**
     * Removes the last element in the array for which the specified predicate returns true.
     *
     * @param pred a Function of the form: function (element :*) :Boolean
     *
     * @return true if an element was removed, false otherwise.
     */
    public static function removeLastIf (arr :Array, pred :Function) :Boolean
    {
        arr.reverse();
        var removed :Boolean = removeFirstIf(arr, pred);
        arr.reverse();
        return removed;
    }

    /**
     * Removes all elements in the array for which the specified predicate returns true.
     *
     * @param pred a Function of the form: function (element :*) :Boolean
     *
     * @return true if an element was removed, false otherwise.
     */
    public static function removeAllIf (arr :Array, pred :Function) :Boolean
    {
        return removeIfImpl(arr, pred, false);
    }

    /**
     * A splice that takes an optional Array of elements to splice in.
     * The function on Array is fairly useless unless you know exactly what you're splicing
     * in at compile time. Fucking varargs.
     */
    public static function splice (
        arr :Array, index :int, deleteCount :int, insertions :Array = null) :Array
    {
        var i :Array = (insertions == null) ? [] : insertions.concat(); // don't modify insertions
        i.unshift(index, deleteCount);
        return arr.splice.apply(arr, i);
    }

    /**
     * Do the two arrays contain elements that are all equals()?
     */
    public static function equals (ar1 :Array, ar2 :Array) :Boolean
    {
        if (ar1 === ar2) {
            return true;

        } else if (ar1 == null || ar2 == null || ar1.length != ar2.length) {
            return false;
        }

        for (var jj :int = 0; jj < ar1.length; jj++) {
            if (!Util.equals(ar1[jj], ar2[jj])) {
                return false;
            }
        }
        return true;
    }

    /**
     * Copy a segment of one array to another.
     * @param src the array to copy from
     * @param srcoffset the position in the source array to begin copying from
     * @param dst the array to copy into
     * @param dstoffset the position in the destition array to begin copying into
     * @param count the number of elements to copy
     */
    public static function copy (
        src :Array, srcoffset :uint, dst :Array, dstoffset :uint, count :uint) :void
    {
        for (var ii :uint = 0; ii < count; ++ii) {
            dst[dstoffset++] = src[srcoffset++];
        }
    }

    /**
     * Implementation of remove methods.
     */
    private static function removeImpl (
        arr :Array, element :Object, firstOnly :Boolean) :Boolean
    {
        return removeIfImpl(arr, Predicates.createEquals(element), firstOnly);
    }

    /**
     * Implementation of removeIf methods.
     */
    private static function removeIfImpl (arr :Array, pred :Function, firstOnly :Boolean) :Boolean
    {
        var removed :Boolean = false;
        for (var ii :int = 0; ii < arr.length; ii++) {
            if (pred(arr[ii])) {
                arr.splice(ii--, 1);
                if (firstOnly) {
                    return true;
                }
                removed = true;
            }
        }
        return removed;
    }
}
}
