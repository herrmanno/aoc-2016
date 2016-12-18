"use strict";

const INPUT_A = '10111100110001111';
const INPUT_B = '00001110011000010';
const INPUT_LENGTH = 17;
const DATA_LENGTH = 272; //35651584;
const CHUNK_SIZE = getChunksize(DATA_LENGTH);
const CHECKSUM_LENGTH = DATA_LENGTH / CHUNK_SIZE;

/**
 * @param {number} pos
 * @returns {number} number of ther joiner or -1 if there is no joiner at the position
 */
function isJoiner(pos) {
    const isJoiner = pos !== 0 && (pos % INPUT_LENGTH) === 0;

    if(isJoiner) {
        return pos / INPUT_LENGTH;
    }
    else {
        return -1;
    }
}

/**
 * @param {number} n
 * @returns {string} the n-th joiner from the Dragon-Curve
 */
function joiner(n) {
    const lowmask = n ^ (n-1);
    const abovemask = lowmask + 1;
    const bitAboveLowestOne = n & abovemask;

    return bitAboveLowestOne ? "1" : "0";
}

/**
 * @param {string} str
 * @returns {number}
 */
function countOfOnes(str) {
    return str.split("").reduce((sum, char) => {
        return sum + (char=="1" ? 1 : 0);
    }, 0);
}

/**
 * @param {number} size
 * @returns {number}
 */
function getChunksize(size) {
    let i = size;

    while((i & 1) === 0)
        i = i / 2;

    return size / i;
}

/**
 * @param {number} pos
 * @param {number} offset
 * @returns {string}
 */
function checksum(pos, offset) {
    const LENGTH = offset - pos;
    let ones = 0;


    let rmOffset = pos;
    while(isJoiner(rmOffset) === -1) {
        rmOffset++;
    }
    const rmsLength = rmOffset - pos;
    let remainingAtStart;
    if(isJoiner(rmOffset) % 2 === 0) // first joiner is even -> str before joiner is REVERVED Input!
        remainingAtStart = INPUT_B.slice(-1 * rmsLength).slice(0, LENGTH);
    else
        remainingAtStart = INPUT_A.slice(-1 * rmsLength).slice(0, LENGTH);

    // ones += count_of_ones_in_remainingAtStart;
    ones += countOfOnes(remainingAtStart);



    let pairStartPos = pos + rmsLength;
    let numberOfPairs = 0;
    let joiners = "";
    while(pairStartPos + (2*INPUT_LENGTH + 1) < offset) {
        numberOfPairs++;
        joiners += joiner(isJoiner(pairStartPos + INPUT_LENGTH));

        pairStartPos += 2*INPUT_LENGTH + 1;
    }

    ones += numberOfPairs * INPUT_LENGTH;

    ones += countOfOnes(joiners);


    const pairEndPos = pairStartPos;
    let rmeOffset = offset - pairEndPos;
    let remainingAtEnd;
    if(isJoiner(pairEndPos - 1) % 2 === 0) // last joiner is even -> str after joiner is NOT_REVERVED Input!
        remainingAtEnd =INPUT_A.slice(0, rmeOffset);
    else
        remainingAtEnd =INPUT_B.slice(0, rmeOffset);

    ones += countOfOnes(remainingAtEnd);


    if(ones % 2 === 0) {
        return "1";
    }
    else {
        return "0";
    }
}




let cs = "";
let pos = 0;
while(cs.length < CHECKSUM_LENGTH) {
    cs += checksum(pos, pos + CHUNK_SIZE);
    pos += CHUNK_SIZE;
}

console.log(cs);