//
// $Id: Equalable.as 65 2009-08-25 18:42:19Z ray $
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
 * Implemented by classes that can have separate instances indicate that they are equal.
 */
public interface Equalable
{
    /**
     * Returns true to indicate that the specified object is equal to this instance.
     */
    function equals (other :Object) :Boolean;
}
}
