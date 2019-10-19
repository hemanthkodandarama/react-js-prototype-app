/**
 *
 * SoftWidgetWrapper
 *
 */

import styled from 'styled-components';
import { BORDER_GREY_LIGHT, PRIMARY_LIGHT } from 'utils/colors';

const SoftWidgetWrapper = styled.section`
  height: 249px;
  box-shadow: ${props =>
    props.noShadow
      ? 'none'
      : `0em 0.0625em 0.1875em 0em rgba(0, 0, 0, 0.2), 0em 0.0625em 0.0625em 0em rgba(0, 0, 0, 0.14), 0em 0.125em 0.0625em -0.0625em ${BORDER_GREY_LIGHT}`};
  border: ${props =>
    props.noShadow ? '1.3px solid rgba(0, 0, 0, 0.12)' : 'none'};
  background-color: ${PRIMARY_LIGHT};

  &:after {
    content: '';
    display: block;
    clear: both;
  }
`;

export default SoftWidgetWrapper;
