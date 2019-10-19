import { createGlobalStyle } from 'styled-components';
import {
  SECONDARY_BLUE_LIGHT,
  PRIMARY_BLUE_LIGHT,
  PRIMARY_LIGHT,
} from 'utils/colors';
import {
  TABLET_VIEWPORT_WIDTH,
  PHONE_LANDSCAPE_VIEWPORT_WIDTH,
} from 'utils/rwd';

const GlobalStyle = createGlobalStyle`
  html,
  body {
    height: 100%;
    width: 100%;
  }

  body {
    font-family: 'Lato', Helvetica, Arial, sans-serif;
  }

  body.fontLoaded {
    font-family: 'Lato', 'Helvetica Neue', Helvetica, Arial, sans-serif;
  }

  h1 {
    font-size: 32px;
  }

  input, select, button, textarea {
    font-size: inherit;
    font-family: 'Lato', 'Helvetica Neue', Helvetica, Arial, sans-serif;
  }

  select {
    @-moz-document url-prefix() {
      & {
        padding: 7px 11px!important;
      }
    }
  }

  #app {
    background-color: ${PRIMARY_LIGHT};
    min-height: 100%;
    min-width: 100%;
    position: relative;
  }

  div {
    table {
      min-width: unset !important;

      td {
        background-color: ${PRIMARY_LIGHT} !important;
      }
    }
  }

  h1 {
    font-size: 32px;
  }

  p,
  label,
  h3 {
    font-family: 'Lato', Times, 'Times New Roman', serif;
    line-height: 24px;
  }

  input::-webkit-outer-spin-button,
  input::-webkit-inner-spin-button {
    -webkit-appearance: none;
    margin: 0;
}

  input[type="color"],
  input[type="date"],
  input[type="datetime"],
  input[type="datetime-local"],
  input[type="email"],
  input[type="month"],
  input[type="number"],
  input[type="password"],
  input[type="search"],
  input[type="tel"],
  input[type="text"],
  input[type="time"],
  input[type="url"],
  input[type="week"],
  select:focus,
  textarea {
    -webkit-appearance: none;
    -moz-appearance: none;
    appearance: none;
    font-size: 16px;
  }

  textarea:focus,
  input:focus,
  button:focus,
  select:focus {
    outline: none;
  }

  [aria-controls] {
    cursor: auto;
  }

  button {
    border: transparent;
    width: auto;
    overflow: visible;
    background: transparent;
    color: inherit;
    font: inherit;
    line-height: normal;
    -webkit-font-smoothing: inherit;
    -moz-osx-font-smoothing: inherit;
    -webkit-appearance: none;
  }

  select:focus,
  textarea {
    font-size: 16px;
  }

  input[type='number'] {
    -moz-appearance:textfield;
  }

  .recharts-wrapper {
    width: 73px!important;
    height: 78px!important;
    
    .recharts-surface {
      width: 100%;
      height: 74px;
    }
  }

  .cssTransforms {
    transition: 0.1s;
  }

  [disabled] {
    opacity: 0.3;
    cursor: auto;

    &:hover {
      background-color: unset;
    }
  }

  .active {
    &:hover {
      cursor: unset;
    }

    .icon {
      color: ${PRIMARY_LIGHT}!important;
    }
  }

  .icon {
    color: ${PRIMARY_BLUE_LIGHT}!important;
    position: relative;
    margin: 0!important;
    top: -1px!important;
    font-size: 28.5px!important;

    @media screen and (min-width: ${PHONE_LANDSCAPE_VIEWPORT_WIDTH}) {
      margin: 0 5px 0 0!important;
    }
  }

  .snackbar__provider,
  .snackbar__provider--open-menu,
  .snackbar__provider--close-menu {
    left: 0!important;
    right: 0!important;
    bottom: 0!important;

    div {
      background-color: ${SECONDARY_BLUE_LIGHT}!important;
    }
  }
  
  @media screen and (min-width: ${TABLET_VIEWPORT_WIDTH}) {
    .snackbar__provider--open-menu {
      left: 280px!important; 
      bottom: 20px!important;
      right: auto!important;
      position: absolute; 
    }
  }

  @media screen and (min-width: 960px) {
    .snackbar__provider,
    .snackbar__provider--close-menu {
      left: 24px!important;
      right: auto!important;
      bottom: 20px!important;
    }
  }
`;

export default GlobalStyle;
