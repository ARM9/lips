const fs = require('fs'),
      path = require('path'),
      jison = require('jison'),
      util = require('util');

function pr(){console.log(...arguments);}
function pp(obj){console.log(util.inspect(obj, false, null, true));}

const grammar = fs.readFileSync('parser.jison', 'utf8'),
      parser = jison.Parser(grammar);
//const parser = require('./parser');

const argv = process.argv.slice(2);

let in_file = '-',
    input = '',
    out_file = '';

if (argv.length === 1) {
    in_file = argv[0];
}

if (in_file === '-' || in_file === '') {
    process.stdin.on('data', function (data) {
        input += data;
    });
    process.stdin.on('end', function () {
        main();
    })
} else {
    let file = path.parse(in_file);
    out_file = file.name + '.o';
    input = fs.readFileSync(in_file, 'utf8');

    main();
}


//let source = fs.readFileSync(args[0]);
//let ast = parser.parse(source);
function main () {
    let ast = parser.parse(input);
    pr();
    pp(ast);
}

