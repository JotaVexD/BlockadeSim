//
// $Id: Iterator.as 5983 2009-10-27 00:57:48Z ray $
//
// Narya library - tools for developing networked games
// Copyright (C) 2002-2009 Three Rings Design, Inc., All Rights Reserved
// http://www.threerings.net/code/narya/
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
 * An Iterator interface for ActionScript.
 * Flex defines IViewCursor, but it defines 14 methods and 5 read-only properties, which
 * is a large implementation burden. This provides a simpler alternative.
 */
public interface Iterator
{
    /**
     * Is there another element available?
     */
    function hasNext () :Boolean;

    /**
     * Returns the next element.
     */
    function next () :Object;

    /**
     * Remove the last returned element.
     */
    function remove () :void;
}
}
