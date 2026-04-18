import * as $rd from "$/gossamer/gossamer/request_destination.mjs";

export function fromRequestDestination(
  value: string,
): $rd.RequestDestination$ {
  switch (value) {
    case "audio":
      return $rd.RequestDestination$Audio();
    case "audioworklet":
      return $rd.RequestDestination$AudioWorklet();
    case "document":
      return $rd.RequestDestination$Document();
    case "embed":
      return $rd.RequestDestination$Embed();
    case "":
      return $rd.RequestDestination$Empty();
    case "font":
      return $rd.RequestDestination$Font();
    case "frame":
      return $rd.RequestDestination$Frame();
    case "iframe":
      return $rd.RequestDestination$Iframe();
    case "image":
      return $rd.RequestDestination$Image();
    case "json":
      return $rd.RequestDestination$Json();
    case "manifest":
      return $rd.RequestDestination$Manifest();
    case "object":
      return $rd.RequestDestination$Object();
    case "paintworklet":
      return $rd.RequestDestination$PaintWorklet();
    case "report":
      return $rd.RequestDestination$Report();
    case "script":
      return $rd.RequestDestination$Script();
    case "sharedworker":
      return $rd.RequestDestination$SharedWorker();
    case "style":
      return $rd.RequestDestination$Style();
    case "track":
      return $rd.RequestDestination$Track();
    case "video":
      return $rd.RequestDestination$Video();
    case "worker":
      return $rd.RequestDestination$Worker();
    case "xslt":
      return $rd.RequestDestination$Xslt();
    default:
      return $rd.RequestDestination$Other(value);
  }
}
