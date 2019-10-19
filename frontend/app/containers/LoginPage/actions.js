/*
 *
 * LoginPage actions
 *
 */

import {
  CHANGE_LOGIN,
  ENTER_LOGIN,
  ENTER_LOGIN_SUCCESS,
  ENTER_LOGIN_ERROR,
  CHANGE_PASSWORD,
  ENTER_PASSWORD,
  ENTER_PASSWORD_SUCCESS,
  ENTER_PASSWORD_ERROR,
  STEP_NEXT,
  STEP_BACK,
  LOGIN,
  LOGIN_SUCCESS,
  LOGIN_ERROR,
  IS_LOGGED,
} from './constants';

export function isLoggedAction() {
  return {
    type: IS_LOGGED,
  };
}

export function changeLoginAction(login) {
  return {
    type: CHANGE_LOGIN,
    login,
  };
}

export function enterLoginAction(login) {
  return {
    type: ENTER_LOGIN,
    login,
  };
}

export function enterLoginSuccessAction() {
  return {
    type: ENTER_LOGIN_SUCCESS,
  };
}

export function enterLoginErrorAction(error) {
  return {
    type: ENTER_LOGIN_ERROR,
    error,
  };
}

export function changePasswordAction(password) {
  return {
    type: CHANGE_PASSWORD,
    password,
  };
}

export function enterPasswordAction(password) {
  return {
    type: ENTER_PASSWORD,
    password,
  };
}

export function enterPasswordSuccessAction() {
  return {
    type: ENTER_PASSWORD_SUCCESS,
  };
}

export function enterPasswordErrorAction(error) {
  return {
    type: ENTER_PASSWORD_ERROR,
    error,
  };
}

export function stepNextAction() {
  return {
    type: STEP_NEXT,
  };
}

export function stepBackAction() {
  return {
    type: STEP_BACK,
  };
}

export function loginAction(login, password) {
  return {
    type: LOGIN,
    login,
    password,
  };
}

export function loginSuccessAction() {
  return {
    type: LOGIN_SUCCESS,
  };
}

export function loginErrorAction(error) {
  return {
    type: LOGIN_ERROR,
    error,
  };
}
