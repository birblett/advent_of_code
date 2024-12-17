let fs = require('fs'), readline = require('readline');

let file = readline.createInterface({ input: fs.createReadStream('in.txt'), output: process.stdout, terminal: false });
let graph : Map<number, Map<number, boolean>> = new Map(), lines : number[][] = [];

file.on('line', (line : string) => {
    let out : string[] = line.trim().split("|");
    if (out.length == 2) {
        let key : number = parseInt(out[0]);
        if (graph.get(key) == null) graph.set(key, new Map());
        graph.get(key).set(parseInt(out[1]), true);
    }
    else if (out[0].length > 0) lines.push(out[0].split(",").map((s : string) => parseInt(s)));
}).on('close', () => {
    console.log(lines.reduce(((arr : number[], line : number[], _, __) => {
        let s : number[] = [], good : boolean = true;
        while (line.length > 0) {
            let bad : number[] = [], rm : number = line.splice(0, 1)[0];
            s.forEach((v : number, i : number, _) => { if (graph.get(rm) && graph.get(rm).get(v)) bad.push(i) });
            if (bad.length != 0) {
                good = false;
                bad.reverse().forEach((i : number, _, __) => { line.push(s.splice(i, 1)[0]) });
            }
            s.push(rm);
        }
        if (s.length == 1) console.log(s)
        return [arr[0] + (good ? s[Math.floor(s.length / 2)] : 0), arr[1] + (good ? 0 : s[Math.floor(s.length / 2)])]
    }), [0, 0]))
})