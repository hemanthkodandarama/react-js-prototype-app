/**
 *
 * Footer
 *
 */

import React, { Fragment } from 'react';
import { useSelector } from 'react-redux';
import { NavLink, withRouter } from 'react-router-dom';
import { FormattedMessage } from 'react-intl';
import { createStructuredSelector } from 'reselect';

// Import Components
import ErrorOutline from '@material-ui/icons/ErrorOutline';
import ErrorOutlineIconWrapper from './ErrorOutlineIconWrapper';
import FooterWrapper from './FooterWrapper';
import FooterTitleWrapper from './FooterTitleWrapper';
import FooterTextWrapper from './FooterTextWrapper';
import FooterAlertWrapper from './FooterAlertWrapper';
import ButtonWrapper from './ButtonWrapper';
import PrivacyWrapper from './PrivacyWrapper';
import messages from './messages';

// Import Selectors
import { makeSelectLocation } from 'containers/App/selectors';

const stateSelector = createStructuredSelector({
  location: makeSelectLocation(),
});

function Footer() {
  const { location } = useSelector(stateSelector);

  return (
    <FooterWrapper>
      <FooterTitleWrapper location={location.pathname}>
        {location.pathname === '/login' ? (
          <Fragment>
            <FormattedMessage {...messages.boldMainText} />
            <NavLink to="/register">
              <ButtonWrapper type="button">
                <FormattedMessage {...messages.registerButton} />
              </ButtonWrapper>
            </NavLink>
          </Fragment>
        ) : (
          <Fragment>
            <FormattedMessage {...messages.boldMainTextLogin} />
            <NavLink to="/login">
              <ButtonWrapper type="button">
                <FormattedMessage {...messages.loginButton} />
              </ButtonWrapper>
            </NavLink>
          </Fragment>
        )}
      </FooterTitleWrapper>

      <FooterTextWrapper header>
        <ErrorOutlineIconWrapper>
        <ErrorOutline />
        </ErrorOutlineIconWrapper>
        <FormattedMessage {...messages.footerInfo1} />
      </FooterTextWrapper>

      <FooterTextWrapper>
        <FormattedMessage {...messages.footerInfo2} />
        <ul>
          <li>
            <FormattedMessage {...messages.footerLiElement1} />
          </li>
          <li>
            <FormattedMessage {...messages.footerLiElement2} />
          </li>
        </ul>
      </FooterTextWrapper>

      <FooterAlertWrapper>
        <FormattedMessage {...messages.footerAlertText1} />
      </FooterAlertWrapper>

      <FooterTextWrapper location={location.pathname}>
        <Fragment>
          <FormattedMessage {...messages.footerAlertText2} />
          <NavLink to="/privacy">
            <PrivacyWrapper type="button">
              <FormattedMessage {...messages.privacyRules} />
            </PrivacyWrapper>
          </NavLink>
        </Fragment>
      </FooterTextWrapper>
    </FooterWrapper>
  );
}

export default withRouter(Footer);
