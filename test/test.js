// Generated by CoffeeScript 1.8.0
(function() {
  var Car, Limo, c1, c2, extend, extendT, iterator, iteratorF, iteratorP, l1, l2, tio, type, typeT, _ref;

  tio = require("../bin/tio").tio;

  _ref = require("../bin/index"), type = _ref.type, extend = _ref.extend, iterator = _ref.iterator;

  typeT = tio("type", function(i) {
    return type(i.f).apply(null, i.a);
  });

  extendT = tio("extend", function(i) {
    return extend(i.type, i.fun).apply(null, i.a);
  });

  iteratorF = tio("iterator#function call", function(i) {
    return iterator.apply(null, i.all)[i.meth].apply(null, i.a)();
  });

  iteratorP = tio("iterator#property get", function(i) {
    var c, e, m;
    m = Array.prototype[i.meth];
    c = iterator.apply(null, i.all)[i.prop]();
    e = c[i.meth].apply(c, i.a);
    return e();
  });

  Car = type(function(color) {
    return {
      color: color,
      brad: function(name) {
        return "" + name + "'s car is " + this.color + ".";
      }
    };
  });

  Limo = extend(Car, function(length) {
    return {
      length: length,
      brad: function(name) {
        return "" + name + "'s limo measure " + this.length + "m.";
      }
    };
  });

  c1 = Car("red");

  c2 = Car("yellow");

  l1 = Limo("black", 2);

  l2 = Limo("green", 3);

  typeT("simple", {
    i: {
      f: function(foo) {
        return {
          foo: foo
        };
      },
      a: ["a"]
    },
    o: {
      foo: "a"
    }
  });

  typeT("more args", {
    i: {
      f: function(a, b, c, d) {
        return {
          a: a,
          b: b,
          c: c,
          d: d
        };
      },
      a: [0, 1, 2, 3]
    },
    o: {
      a: 0,
      b: 1,
      c: 2,
      d: 3
    }
  });

  extendT("simple", {
    i: {
      type: Car,
      fun: function(length) {
        return {
          length: length
        };
      },
      a: ["yellow", 4]
    },
    o: {
      length: 4,
      color: "yellow",
      brad: function() {}
    }
  });

  iteratorF("simple", {
    i: {
      all: [c1, c2, l1, l2],
      meth: "brad",
      a: ["Jon"]
    },
    o: ["Jon's car is red.", "Jon's car is yellow.", "Jon's limo measure 2m.", "Jon's limo measure 3m."]
  });

  iteratorP("simple", {
    i: {
      all: [c1, c2, l1, l2],
      prop: "color",
      meth: "slice",
      a: []
    },
    o: ["red", "yellow", "black", "green"]
  });

}).call(this);
