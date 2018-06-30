---
title: "Jest Snapshots: Reducing styled-jsx Noise"

description: "Learn how to eliminate the noise in your diffs when using Jest snapshots with styled-jsx."

tags:
- jest
- react
- styled-jsx

pull_image: "/images/2018-04-11-jest-snapshots-reducing-styled-jsx-noise/telescope.jpg"
pull_image_attribution: '[Total Eclipse Light](https://flickr.com/photos/howardignatius/13875481115 "Total Eclipse Light") by [howardignatius](https://flickr.com/people/howardignatius) is licensed under [CC BY-NC-ND](https://creativecommons.org/licenses/by-nc-nd/2.0/)'
---

Facebook's [Jest](https://facebook.github.io/jest/) is a powerful testing framework for JavaScript. It works _out of the box_ for React projects and is essentially the de facto testing framework for React. When I began using Jest in combination with React I fell in love with the [snapshot testing](https://facebook.github.io/jest/docs/en/snapshot-testing.html#snapshot-testing-with-jest) functionality. Having snapshots helps detect structural regressions in the rendered DOM, as per the homepage's documentation:

> Capture snapshots of React trees or other serializable values to simplify testing and to analyze how state changes over time.

During my work with React and Jest, I was using [`styled-jsx`](https://github.com/zeit/styled-jsx) as my [CSS-in-JS](https://hackernoon.com/all-you-need-to-know-about-css-in-js-984a72d48ebc) technology choice. Many times, I saw the following when I made any CSS changes:

```
FAIL  src/App.test.js
● renders without crashing

  expect(value).toMatchSnapshot()

  Received value does not match stored snapshot 1.

  - Snapshot
  1. Received

  @@ -1,28 +1,23 @@
   <div
  -  className="jsx-188895008 App"
  +  className="jsx-3481390381 App"
   >
```
This is because the CSS changed for this scoped component and thus the `jsx-########` (unique id) reflects the change.

To me, these changes in the snapshot diffs are noise and it is harder to see the structural DOM changes. The original `className` for the DOM elements are still present, and ideally, I would just want snapshots without any of the `styled-jsx` stuff present.

We will first start with a simplified `App` component using [create-react-app](https://github.com/facebook/create-react-app) as the base. The goal is to illustrate the project setup, what the snapshots look like, how to reduce the noise, and what the snapshots look like afterwards. `styled-jsx` provides a way to style your components using _inline styles_ or _external CSS files_, so we will consider both in this article. In addition, we will also consider both the `react-test-renderer` and `enzyme` Jest snapshot rendering methods.

Given the above information, the following sections will cover these scenarios:

  - Inline styles with `react-test-renderer`
  - Inline styles with `enzyme`
  - External styles with `react-test-renderer`
  - External styles with `enzyme`

## Inline Styles

```jsx
import React, { Component } from 'react';

class App extends Component {
  render() {
    return (
      <div className="App">
        <p>
          Example Component
        </p>
        <style jsx>{`
          .App {
            text-align: center;
          }
        `}</style>
      </div>
    );
  }
}

export default App;
```

To make this all work, you have to add the `styled-jsx/babel` to _plugins_ in the babel configuration.

```json
"babel": {
  "presets": [
    "react-app"
  ],
  "plugins": [
    "styled-jsx/babel"
  ]
}
```

### Snapshots with react-test-renderer

Within the context of inline styles, we'll first look at the default approach for testing with Jest snapshots using [`react-test-renderer`](https://github.com/facebook/react/tree/master/packages/react-test-renderer).

```jsx
import React from 'react';
import ReactDOM from 'react-dom';
import renderer from 'react-test-renderer';

import App from './App';

it('renders without crashing', () => {
  const tree = renderer.create(<App />).toJSON();
  expect(tree).toMatchSnapshot();
});
```

This generates the following snapshot:

```
exports[`renders without crashing 1`] = `
<div
  className="jsx-188096426 App"
>
  <p
    className="jsx-188096426"
  >
    Example Component
  </p>
</div>
`;
```

If we change one aspect of the CSS (i.e., the `text-align` value), we get the following snapshot diff:

```diff
- Snapshot
+ Received

 <div
-  className="jsx-188096426 App"
+  className="jsx-1500233327 App"
 >
   <p
-    className="jsx-188096426"
+    className="jsx-1500233327"
   >
     Example Component
   </p>
 </div>
 ```

We can see the `jsx-########` noise in our diff. One other thing to note here is that the `p` element also has the noise even though our CSS doesn't target it!

To eliminate this noise, let us remove the `styled-jsx/babel` plugin from the test environment (you will want to specify your different environments):

```json
"babel": {
  "presets": [
    "react-app"
  ],
  "env": {
    "production": {
      "plugins": [
        "styled-jsx/babel"
      ]
    },
    "development": {
      "plugins": [
        "styled-jsx/babel"
      ]
    },
    "test": {
      "plugins": [
      ]
    }
  }
}
```

Now you have a snapshot that looks like this:

```
exports[`renders without crashing 1`] = `
<div
  className="App"
>
  <p>
    Example Component
  </p>
  <style
    jsx={true}
  >

              .App {
                text-align: center;
              }

  </style>
</div>
`;
```

As we can see, the `jsx-########` values are no longer present, although there is now a `style` element which has the actual CSS. In my opinion, this is a good trade -- now every element doesn't have the ever-changing `jsx-########`. This alone results in cleaner snapshots from my perspective.

### Snapshots with enzyme

The second approach we will look at for inline styles is snapshot testing with [`enzyme`](https://github.com/airbnb/enzyme). This package gives you the additional functionality to assert and manipulate the component's output. Unfortunately, the rendered component is wrapped in an `enzyme` specific component, which produces unnecessarily complex snapshots. Fortunately, the [`enzyme-to-json`](https://github.com/adriantoine/enzyme-to-json) package provides an approach to convert the wrapped component to the standard format we're familiar with. It is worth noting that you can further simplify the setup if you read more into the documentation of `enzyme` and `enzyme-to-json`.

```jsx
import React from 'react';
import ReactDOM from 'react-dom';
import Enzyme from 'enzyme';
import Adapter from 'enzyme-adapter-react-16';
import { shallow } from 'enzyme';
import toJson from 'enzyme-to-json';

import App from './App';

Enzyme.configure({ adapter: new Adapter() });

it('renders without crashing', () => {
  const wrapper = shallow(<App />);
  expect(toJson(wrapper)).toMatchSnapshot();
});
```

This generates the following snapshot:

```
exports[`renders without crashing 1`] = `
<div
  className="jsx-188096426 App"
>
  <p
    className="jsx-188096426"
  >
    Example Component
  </p>
  <JSXStyle
    css=".App.jsx-188096426{text-align:center;}"
    styleId="188096426"
  />
</div>
`;
```

Notice here that we have an additional `JSXStyle` element that contains the actual CSS styles. This is _in addition_ to the original noise we have in our snapshot.

If we change one aspect of the CSS (i.e., the `text-align` value), we get the following snapshot readout:

```diff
- Snapshot
+ Received

 <div
-  className="jsx-188096426 App"
+  className="jsx-1500233327 App"
 >
   <p
-    className="jsx-188096426"
+    className="jsx-1500233327"
   >
     Example Component
   </p>
   <JSXStyle
-    css=".App.jsx-188096426{text-align:center;}"
-    styleId="188096426"
+    css=".App.jsx-1500233327{text-align:left;}"
+    styleId="1500233327"
   />
 </div>
```

If we apply the same fix as we did for inline styles with `react-test-renderer` (removing `styled-jsx/babel` plugin from the test environment), we now get the same snapshot output. Thus, there are no more `jsx-########` values, however the raw CSS is within the `style` tag.

## External Styles

I personally like to use [external CSS files](https://github.com/zeit/styled-jsx#external-css-and-styles-outside-of-the-component) that I import into the components. The following shows our converted `App` component to use an imported CSS file instead of an inline style:

```jsx
import React, { Component } from 'react';
import css from './App.css';

class App extends Component {
  render() {
    return (
      <div className="App">
        <p>
          Example Component
        </p>
        <style jsx>{css}</style>
      </div>
    );
  }
}

export default App;
```

```js
import css from 'styled-jsx/css';

export default css`
  .App {
    text-align: center;
  }
`;
```

### Snapshots with react-test-renderer

Using external CSS files has no impact on _how_ we test the component. Thus, we can use the same test from the inline styles section. Since that is the case, let us take the same approach to eliminate the noise in the diff by removing the `styled-jsx/babel` plugin from the test environment.

```
FAIL  src/App.test.js
● Test suite failed to run

  styled-jsx/css: if you are getting this error it means that your `css` tagged template literals were not transpiled.

    at Object.<anonymous>.module.exports [as default] (node_modules/styled-jsx/css.js:2:9)
    at Object.<anonymous> (src/App.css.js:3:14)
    at Object.<anonymous> (src/App.js:2:12)
    at Object.<anonymous> (src/App.test.js:5:12)
```

We can recover from this error, if we use a [Jest manual mocks](https://facebook.github.io/jest/docs/en/manual-mocks.html) to mock out the `css` tagged template literal. We can accomplish this by creating the following mock under `__mocks__/styled-jsx/css.js`:

```js
function css() {
  return '';
}

module.exports = css;
```
Now our snapshot looks like the following:

```
exports[`renders without crashing 1`] = `
<div
  className="App"
>
  <p>
    Example Component
  </p>
  <style
    jsx={true}
  />
</div>
`;
```

We can see that the `jsx-########` values are no longer present, and in addition, the `style` tag does not have the raw CSS. This is an improvement over the inline style approaches, as the snapshot doesn't change with any CSS changes.

### Snapshots with enzyme

We can use the same test we had when testing the inline styles using `react-test-renderer`. Going from what we know now, we can remove the `styled-jsx/babel` plugin from the test environment and mock the `css` tagged template literal. These two changes then result in the same snapshot that we received in the external styles using `react-test-renderer`.

This is a great outcome given that the use of `enzyme` is common in the React tests I write, and it offers the _cleanest_ snapshots.

## TL;DR

- If you are using `styled-jsx` with Jest snapshots:
  - You will see `className` changes for the `jsx-########` values any time the CSS changes
- If you are using inline styles:
  - _Remove_ the `styled-jsx/babel` plugin from your test environment
  - See clean snapshots when using `react-test-renderer`
  - See clean snapshots (except for raw CSS under `style` tag) when using `enzyme`
- If you are using external styles:
  - _Remove_ the `styled-jsx/babel` plugin from your test environment
  - _Mock_ the `css` tagged template literal for `styled-jsx`
  - See clean snapshots when using `react-test-renderer`
  - See clean snapshots when using `enzyme`

There might be a better way to handle this, but as of the time this article was written I have yet to see a clean approach. One thing I noticed was a [GitHub comment](https://github.com/zeit/styled-jsx/issues/117#issuecomment-342115323) that alluded to a better method that would follow a similar strategy to [jest-styled-components](https://github.com/styled-components/jest-styled-components) but for `styled-jsx`.
