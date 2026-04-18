import * as $httpStatus from "$/gossamer/gossamer/http_status.mjs";

export function toHttpStatus(code: number): $httpStatus.HttpStatus$ {
  switch (code) {
    case 100:
      return $httpStatus.HttpStatus$Continue();
    case 101:
      return $httpStatus.HttpStatus$SwitchingProtocols();
    case 200:
      return $httpStatus.HttpStatus$Ok();
    case 201:
      return $httpStatus.HttpStatus$Created();
    case 202:
      return $httpStatus.HttpStatus$Accepted();
    case 204:
      return $httpStatus.HttpStatus$NoContent();
    case 206:
      return $httpStatus.HttpStatus$PartialContent();
    case 301:
      return $httpStatus.HttpStatus$MovedPermanently();
    case 302:
      return $httpStatus.HttpStatus$Found();
    case 303:
      return $httpStatus.HttpStatus$SeeOther();
    case 304:
      return $httpStatus.HttpStatus$NotModified();
    case 307:
      return $httpStatus.HttpStatus$TemporaryRedirect();
    case 308:
      return $httpStatus.HttpStatus$PermanentRedirect();
    case 400:
      return $httpStatus.HttpStatus$BadRequest();
    case 401:
      return $httpStatus.HttpStatus$Unauthorized();
    case 403:
      return $httpStatus.HttpStatus$Forbidden();
    case 404:
      return $httpStatus.HttpStatus$NotFound();
    case 405:
      return $httpStatus.HttpStatus$MethodNotAllowed();
    case 409:
      return $httpStatus.HttpStatus$Conflict();
    case 410:
      return $httpStatus.HttpStatus$Gone();
    case 413:
      return $httpStatus.HttpStatus$PayloadTooLarge();
    case 415:
      return $httpStatus.HttpStatus$UnsupportedMediaType();
    case 418:
      return $httpStatus.HttpStatus$ImATeapot();
    case 422:
      return $httpStatus.HttpStatus$UnprocessableContent();
    case 429:
      return $httpStatus.HttpStatus$TooManyRequests();
    case 500:
      return $httpStatus.HttpStatus$InternalServerError();
    case 501:
      return $httpStatus.HttpStatus$NotImplemented();
    case 502:
      return $httpStatus.HttpStatus$BadGateway();
    case 503:
      return $httpStatus.HttpStatus$ServiceUnavailable();
    case 504:
      return $httpStatus.HttpStatus$GatewayTimeout();
    default:
      return $httpStatus.HttpStatus$Other(code);
  }
}

export function fromHttpStatus(value: $httpStatus.HttpStatus$): number {
  if ($httpStatus.HttpStatus$isContinue(value)) return 100;
  if ($httpStatus.HttpStatus$isSwitchingProtocols(value)) return 101;
  if ($httpStatus.HttpStatus$isOk(value)) return 200;
  if ($httpStatus.HttpStatus$isCreated(value)) return 201;
  if ($httpStatus.HttpStatus$isAccepted(value)) return 202;
  if ($httpStatus.HttpStatus$isNoContent(value)) return 204;
  if ($httpStatus.HttpStatus$isPartialContent(value)) return 206;
  if ($httpStatus.HttpStatus$isMovedPermanently(value)) return 301;
  if ($httpStatus.HttpStatus$isFound(value)) return 302;
  if ($httpStatus.HttpStatus$isSeeOther(value)) return 303;
  if ($httpStatus.HttpStatus$isNotModified(value)) return 304;
  if ($httpStatus.HttpStatus$isTemporaryRedirect(value)) return 307;
  if ($httpStatus.HttpStatus$isPermanentRedirect(value)) return 308;
  if ($httpStatus.HttpStatus$isBadRequest(value)) return 400;
  if ($httpStatus.HttpStatus$isUnauthorized(value)) return 401;
  if ($httpStatus.HttpStatus$isForbidden(value)) return 403;
  if ($httpStatus.HttpStatus$isNotFound(value)) return 404;
  if ($httpStatus.HttpStatus$isMethodNotAllowed(value)) return 405;
  if ($httpStatus.HttpStatus$isConflict(value)) return 409;
  if ($httpStatus.HttpStatus$isGone(value)) return 410;
  if ($httpStatus.HttpStatus$isPayloadTooLarge(value)) return 413;
  if ($httpStatus.HttpStatus$isUnsupportedMediaType(value)) return 415;
  if ($httpStatus.HttpStatus$isImATeapot(value)) return 418;
  if ($httpStatus.HttpStatus$isUnprocessableContent(value)) return 422;
  if ($httpStatus.HttpStatus$isTooManyRequests(value)) return 429;
  if ($httpStatus.HttpStatus$isInternalServerError(value)) return 500;
  if ($httpStatus.HttpStatus$isNotImplemented(value)) return 501;
  if ($httpStatus.HttpStatus$isBadGateway(value)) return 502;
  if ($httpStatus.HttpStatus$isServiceUnavailable(value)) return 503;
  if ($httpStatus.HttpStatus$isGatewayTimeout(value)) return 504;
  return $httpStatus.HttpStatus$Other$0(value);
}
