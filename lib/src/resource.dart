import 'package:http_parser/http_parser.dart';
import 'package:meta/meta.dart';

/// A WebFinger resource, otherwise known as a `JRD`.
class JsonResourceDescriptor {
  /// The WebFinger resource MIME type: `application/jrd+json`.
  static final MediaType contentType = MediaType('application', 'jrd+json');

  /// The file extension associated with WebFinger JRD's.
  static const String fileExtension = '.jrd';

  /// The value of the "subject" member is a URI that identifies the entity
  /// that the JRD describes.
  ///
  /// The "subject" value returned by a WebFinger resource MAY differ from
  /// the value of the "resource" parameter used in the client's request.
  /// This might happen, for example, when the subject's identity changes
  /// (e.g., a user moves his or her account to another service) or when
  /// the resource prefers to express URIs in canonical form.
  ///
  /// The "subject" member SHOULD be present in the JRD.
  final Uri subject;

  /// The "aliases" array is an array of zero or more URI strings that
  /// identify the same entity as the "subject" URI.
  ///
  /// The "aliases" array is OPTIONAL in the JRD.
  final List<Uri> aliases;

  /// The "properties" object comprises zero or more name/value pairs whose
  /// names are URIs (referred to as "property identifiers") and whose
  /// values are strings or null.  Properties are used to convey additional
  /// information about the subject of the JRD.  As an example, consider
  /// this use of "properties":
  ///
  ///
  /// ```json
  /// "properties" : { "http://webfinger.example/ns/name" : "Bob Smith" }
  /// ```
  ///
  /// The "properties" member is OPTIONAL in the JRD.
  final Map<Uri, String> properties;

  /// The "links" array has any number of member objects, each of which
  /// represents a link [4].  Each of these link objects can have the
  /// following members:
  ///
  /// * rel
  /// * type
  /// * href
  /// * titles
  /// * properties
  ///
  /// The "rel" and "href" members are strings representing the link's
  /// relation type and the target URI, respectively.  The context of the
  /// link is the "subject" (see Section 4.4.1).
  ///
  /// The "type" member is a string indicating what the media type of the
  /// result of dereferencing the link ought to be.
  ///
  /// The order of elements in the "links" array MAY be interpreted as
  /// indicating an order of preference.  Thus, if there are two or more
  /// link relations having the same "rel" value, the first link relation
  /// would indicate the user's preferred link.
  ///
  /// The "links" array is OPTIONAL in the JRD.
  final List<LinkRelation> links;

  JsonResourceDescriptor(
      {@required this.subject,
      Iterable<Uri> aliases,
      this.properties,
      Iterable<LinkRelation> links})
      : this.aliases = aliases?.toList(),
        this.links = links?.toList();

  /// Converts this instance into a JSON-friendly representation.
  Map<String, dynamic> toJson() {
    var out = <String, dynamic>{};
    out['subject'] = subject.toString();

    if (aliases != null)
      out['aliases'] = aliases.map((a) => a.toString()).toList();

    if (properties != null)
      out['properties'] =
          properties.map((name, value) => MapEntry(name.toString(), value));

    if (links != null) out['links'] = links.map((l) => l.toJson()).toList();

    return out;
  }
}

/// An object found in the `links` field of a [JsonResourceDescriptor].
class LinkRelation {
  /// The value of the "rel" member is a string that is either a URI or a
  /// registered relation type [8] (see RFC 5988 [4]).  The value of the
  /// "rel" member MUST contain exactly one URI or registered relation
  /// type.  The URI or registered relation type identifies the type of the
  /// link relation.
  ///
  /// The other members of the object have meaning only once the type of
  /// link relation is understood.  In some instances, the link relation
  /// will have associated semantics enabling the client to query for other
  /// resources on the Internet.  In other instances, the link relation
  /// will have associated semantics enabling the client to utilize the
  /// other members of the link relation object without fetching additional
  /// external resources.
  ///
  /// URI link relation type values are compared using the "Simple String
  /// Comparison" algorithm of Section 6.2.1 of RFC 3986.
  ///
  /// The "rel" member MUST be present in the link relation object.
  final String rel;

  /// The value of the "type" member is a string that indicates the media
  /// type ([MediaType]) [9] of the target resource (see RFC 6838 [10]).
  ///
  /// The "type" member is OPTIONAL in the link relation object.
  final String type;

  /// The value of the "href" member is a string that contains a URI
  /// pointing to the target resource.
  ///
  /// The "href" member is OPTIONAL in the link relation object.
  final Uri href;

  /// The "titles" object comprises zero or more name/value pairs whose
  /// names are a language tag [11] or the string "und".  The string is
  /// human-readable and describes the link relation.  More than one title
  /// for the link relation MAY be provided for the benefit of users who
  /// utilize the link relation, and, if used, a language identifier SHOULD
  /// be duly used as the name.  If the language is unknown or unspecified,
  /// then the name is "und".
  ///
  /// A JRD SHOULD NOT include more than one title identified with the same
  /// language tag (or "und") within the link relation object.  Meaning is
  /// undefined if a link relation object includes more than one title
  /// named with the same language tag (or "und"), though this MUST NOT be
  /// treated as an error.  A client MAY select whichever title or titles
  /// it wishes to utilize.
  ///
  /// Here is an example of the "titles" object:
  ///
  /// ```json
  /// "titles" :
  /// {
  ///   "en-us" : "The Magical World of Steve",
  ///   "fr" : "Le Monde Magique de Steve"
  /// }
  /// ```
  ///
  /// The "titles" member is OPTIONAL in the link relation object.
  final Map<String, String> titles;

  /// The "properties" object within the link relation object comprises
  /// zero or more name/value pairs whose names are URIs (referred to as
  /// "property identifiers") and whose values are strings or null.
  /// Properties are used to convey additional information about the link
  /// relation.  As an example, consider this use of "properties":
  ///
  /// ```json
  /// "properties" : { "http://webfinger.example/mail/port" : "993" }
  /// ```
  ///
  /// The "properties" member is OPTIONAL in the link relation object.
  final Map<Uri, String> properties;

  LinkRelation(
      {@required this.rel, this.href, this.type, this.titles, this.properties});

  /// Converts this instance into a JSON-friendly representation.
  Map<String, dynamic> toJson() {
    var out = <String, dynamic>{};
    out['rel'] = rel;
    if (type != null) out['type'] = type;
    if (href != null) out['href'] = href.toString();
    if (titles != null) out['titles'] = titles;
    if (properties != null) {
      out['properties'] =
          properties.map((name, value) => MapEntry(name.toString(), value));
    }

    return out;
  }
}
