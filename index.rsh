'reach 0.1';

const [ isFingers, zero, one, two, three, four, five ] = makeEnum(6);
const [ isGuess, guess0, guess1, guess2, guess3, guess4, guess5, guess6, guess7, guess8, guess9, guess10 ] = makeEnum(11);
const [ isOutcome, bobWins, draw, aliceWins ] = makeEnum(3);

const winner = (fingersA, fingersB, guessA, guessB) => { 
  if ( guessA == guessB ) 
   {
    const outcome = draw; //tie
    return outcome;
  } 
  else {
  if ( ((fingersA + fingersB) == guessA ) ) {
    const outcome = aliceWins;
    return outcome;// player A wins
  } 
    else {
      if (((fingersA + fingersB) == guessB)) {
        const outcome = bobWins;
        return outcome;// player B wins
    } 
      else {
        const outcome = draw; // tie
        return outcome;
      }
    
    }
  }
};

assert(winner(zero, two, guess0, guess0) == bobWins);
assert(winner(two, zero, guess2, guess0) == aliceWins);
assert(winner(zero,one,guess0,guess2)== draw);
assert(winner(one, one,guess1, guess1)== draw);

forall(UInt, fingersA =>
  forall(UInt, fingersB =>
    forall(UInt, guessA =>
      forall(UInt, guessB =>
    assert(isOutcome(winner(fingersA, fingersB, guessA, guessB)))))));

forall(UInt, (fingerA) =>
  forall(UInt, (fingerB) =>       
    forall(UInt, (guess) =>
      assert(winner(fingerA, fingerB, guess, guess) == draw))));    


const Player =
      { ...hasRandom,
        getFingers: Fun([], UInt),
        getGuess: Fun([UInt], UInt),
        seeWinning: Fun([UInt], Null),
        seeOutcome: Fun([UInt], Null) ,
        informTimeout: Fun([], Null)
       };
       
export const main = Reach.App(() => {
  const Alice = Participant('Alice', {
    ...Player,
    wager: UInt,
    deadline: UInt,
  });
  const Bob = Participant('Bob', {
    ...Player,
    acceptWager: Fun([UInt], Null),
  });
  init();

  const informTimeout = () => {
    each([Alice, Bob], () => {
      interact.informTimeout();
    });
  };

  Alice.only(() => {
    const wager = declassify(interact.wager);
    const deadline = declassify(interact.deadline);
    });
    Alice.publish(wager, deadline).pay(wager);
    commit();   

    Bob.only(() => {
      interact.acceptWager(wager); 
    });
    Bob.pay(wager)
    .timeout(relativeTime(deadline), () => closeTo(Alice, informTimeout));

    var outcome = draw;      
    invariant(balance() == 2 * wager && isOutcome(outcome) );

    while (outcome == draw) {
      commit();
      Alice.only(() => {    
        const _fingersA = interact.getFingers();
        const _guessA = interact.getGuess(_fingersA);         
        const [_commitA, _saltA] = makeCommitment(interact, _fingersA);
        const [_guessCommitA, _guessSaltA] = makeCommitment(interact, _guessA);
        const commitA = declassify(_commitA);        
        const guessCommitA = declassify(_guessCommitA);   
      });
     
      Alice.publish(commitA)
      .timeout(relativeTime(deadline), () => closeTo(Bob, informTimeout));
      commit();    

      Alice.publish(guessCommitA).timeout(relativeTime(deadline), () => closeTo(Bob, informTimeout));
      commit();
      unknowable(Bob, Alice(_fingersA, _saltA));
      unknowable(Bob, Alice(_guessA, _guessSaltA));

      Bob.only(() => {
        const _fingersB = interact.getFingers();
        const _guessB = interact.getGuess(_fingersB);
        const fingersB = declassify(_fingersB); 
        const guessB = declassify(_guessB);  
      });

      Bob.publish(fingersB)
        .timeout(relativeTime(deadline), () => closeTo(Alice, informTimeout));
        commit();
      Bob.publish(guessB)
        .timeout(relativeTime(deadline), () => closeTo(Alice, informTimeout));
        commit();
        
        Alice.only(() => {
          const [saltA, fingersA] = declassify([_saltA, _fingersA]); 
          const [guessSaltA, guessA] = declassify([_guessSaltA, _guessA]); 
        });
        Alice.publish(saltA, fingersA)
          .timeout(relativeTime(deadline), () => closeTo(Bob, informTimeout));
        
        checkCommitment(commitA, saltA, fingersA);
        commit();

        Alice.publish(guessSaltA, guessA)
        .timeout(relativeTime(deadline), () => closeTo(Bob, informTimeout));
        checkCommitment(guessCommitA, guessSaltA, guessA);

        commit();
      
        Alice.only(() => {        
          const WinningNumber = fingersA + fingersB;
          interact.seeWinning(WinningNumber);
        });
     
        Alice.publish(WinningNumber)
        .timeout(relativeTime(deadline), () => closeTo(Alice, informTimeout));

        outcome = winner(fingersA, fingersB, guessA, guessB);
        continue; 
      }

      assert(outcome == aliceWins || outcome == bobWins);
      transfer(2 * wager).to(outcome == aliceWins ? Alice : Bob);
      commit();
      each([Alice, Bob], () => {
        interact.seeOutcome(outcome); 
      });
});