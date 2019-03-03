import React from 'react'
import ReactDOM from 'react-dom'

const Result = props => {
    return (
        <div style={{ margin: '1em' }}>
            <div className={'well'}>
                <div style={{ fontWeight: 'bold' }}>Prefix: {props.value}</div>
                <div>Name: {props.comment}</div>
            </div>
        </div>
    )
}

const ResultList = ({ results = [] }) => (
    <div>


        {results.map(result => <Result key={result.id} {...result} />)}
    </div>
);

class Form extends React.PureComponent {
    state = {
        token: ''
    };

    componentDidMount() {
        const token = document.getElementsByName('csrf-token')[0].content;
        this.setState({ token });
    }

    handleSubmit = event => {
        event.preventDefault();
        const data = new FormData(event.target);

        fetch('/search', {
            method: 'POST',
            body: data,
        })
            .then(response => response.json())
            .then(
                data =>
                    this.props.onSubmit(data)
            );
    };




render() {
        return (
            <form onSubmit={this.handleSubmit}>
                <input type='hidden' name='authenticity_token' value={this.state.token} />
                <label htmlFor={'search_string'}> Enter prefix or service provider name. You can divide your searches by comma</label>
                <input className={'form-control'}
                       name="search_string"
                       placeholder={'Enter prefix or service provider.'}
                       type="text" />
                <br/>
                <button type={'submit'}
                        className={'btn btn-primary'}>
                    Search
                </button>
            </form>
        );
    }
}

class App extends React.Component {
    state = {
        results: []
    };

    setResults = results => this.setState({ results });

    render() {
        return (
            <div>
                <Form onSubmit={this.setResults} />
                <hr />
                <ResultList results={this.state.results} />
            </div>
        );
    }
}

ReactDOM.render(<App />, document.getElementById('root'));



