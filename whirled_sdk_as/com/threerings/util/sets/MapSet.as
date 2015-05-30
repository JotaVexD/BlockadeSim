//
// $Id: MapSet.as 86 2009-09-01 21:13:17Z ray $
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

package com.threerings.util.sets {

import com.threerings.util.Map;
import com.threerings.util.Preconditions;
import com.threerings.util.Set;

/**
 * A Set that uses a Map for backing store, thus allowing us to build on the
 * various Maps in useful ways.
 */
public class MapSet
    implements Set
{
    public function MapSet (source :Map)
    {
        _source = Preconditions.checkNotNull(source);
    }

    /** @inheritDoc */
    public function add (o :Object) :Boolean
    {
        return (undefined === _source.put(o, true));
    }

    /** @inheritDoc */
    public function contains (o :Object) :Boolean
    {
        return _source.containsKey(o);
    }

    /** @inheritDoc */
    public function remove (o :Object) :Boolean
    {
        return (undefined !== _source.remove(o));
    }

    /** @inheritDoc */
    public function size () :int
    {
        return _source.size();
    }

    /** @inheritDoc */
    public function isEmpty () :Boolean
    {
        return _source.isEmpty();
    }

    /** @inheritDoc */
    public function clear () :void
    {
        return _source.clear();
    }

    /** @inheritDoc */
    public function toArray () :Array
    {
        return _source.keys();
    }

    /** @inheritDoc */
    public function forEach (fn :Function) :void
    {
        _source.forEach(function (k :Object, v :Object) :* {
            return fn(k);
        });
    }

    /** The map used for our source. @private */
    protected var _source :Map;
}
}