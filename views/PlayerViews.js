import React from 'react';

const exports = {};
exports.GetFingers = class extends React.Component {
  render() {
    const {parent, playable, finger} = this.props;
    return (
      <div>
        {finger ? 'It was a draw! Pick again.' : ''}
        <br />
        {!playable ? 'Please wait...' : ''}
        <br />
        <br />
        How many fingers do you want to play?

        <br />
        <button
          disabled={!playable}
          onClick={() => parent.playFingers('0')}
        >0</button>
        <button
          disabled={!playable}
          onClick={() => parent.playFingers('1')}
        >1</button>
        <button
          disabled={!playable}
          onClick={() => parent.playFingers('2')}
        >2</button>
        <button
          disabled={!playable}
          onClick={() => parent.playFingers('3')}
        >3</button>
        <button
          disabled={!playable}
          onClick={() => parent.playFingers('4')}
        >4</button>
        <button
          disabled={!playable}
          onClick={() => parent.playFingers('5')}
        >5</button>
      </div>
    );
  }
}

exports.GetGuess = class extends React.Component {
  render() {
    const {parent, playable, guess} = this.props;
    return (
      <div>
        {guess ? 'It was a draw! Pick again.' : ''}
        <br />
        {!playable ? 'Please wait...' : ''}
        <br />
        <br />
        What is your guess?
        
        <br />
        <button
          disabled={!playable}
          onClick={() => parent.setGuess('0')}
        >0</button>
        <button
          disabled={!playable}
          onClick={() => parent.setGuess('1')}
        >1</button>
        <button
          disabled={!playable}
          onClick={() => parent.playFingers('2')}
        >2</button>
        <button
          disabled={!playable}
          onClick={() => parent.playFingers('3')}
        >3</button>
        <button
          disabled={!playable}
          onClick={() => parent.playFingers('4')}
        >4</button>
        <button
          disabled={!playable}
          onClick={() => parent.playFingers('5')}
        >5</button>
        <button
          disabled={!playable}
          onClick={() => parent.setGuess('6')}
        >6</button>
        <button
          disabled={!playable}
          onClick={() => parent.setGuess('7')}
        >7</button>
        <button
          disabled={!playable}
          onClick={() => parent.setGuess('8')}
        >8</button>
        <button
          disabled={!playable}
          onClick={() => parent.setGuess('9')}
        >9</button>
        <button
          disabled={!playable}
          onClick={() => parent.setGuess('10')}
        >10</button>
      </div>
    );
  }
}

exports.WaitingForResults = class extends React.Component {
  render() {
    return (
      <div>
        Waiting for results...
      </div>
    );
  }
}

exports.Winning = class extends React.Component {
  render() {
    const {winning} = this.props;
    return (
      <div>
        The winning guess was:
        <br />{winning || 'Unknown'}
      </div>
    );
  }
}

exports.Done = class extends React.Component {
  render() {
    const {outcome} = this.props;
    const {winning} = this.props;
    return (
      <div>
        Thank you for playing. The outcome of this game was:
        <br />{outcome || 'Unknown'}
      </div>
    );
  }
}

exports.Timeout = class extends React.Component {
  render() {
    return (
      <div>
        There's been a timeout. (Someone took too long.)
      </div>
    );
  }
}

export default exports;