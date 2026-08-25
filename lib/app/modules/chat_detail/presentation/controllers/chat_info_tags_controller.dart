import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/widgets/rich_text_wrapper/controllers/controller.dart';
import 'package:ts_admin/app/modules/chat_detail/data/enums/chat_info_tags.dart';
import 'package:ts_admin/app/modules/chat_detail/data/models/chat_info_tags_model.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/chat_info_tags_entity.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/usecases/get_chat_info_tags_usecase.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/controllers/chat_detail_controller.dart';
import 'package:ts_admin/app/services/injection_service.dart';

class ChatInfoTagsController extends GetxController {
  late RichTextController richTextController;

  final Rx<ChatInfoTagsModel> chatInfoTags =
      // ignore: prefer_const_constructors, prefer_const_literals_to_create_immutables
      Rx(ChatInfoTagsModel(driver: [], truck: [], shipment: []));

  ///
  ///
  /// scroll controllers

  final ScrollController driversScrollControl = ScrollController();
  final ScrollController trucksScrollControl = ScrollController();
  final ScrollController shipmentsScrollControl = ScrollController();

  ///
  ///
  /// use cases

  final getChatInfoTagsUsercase = sl<GetChatInfoTagsUsecase>();

  ///
  ///
  /// data variables
  ChatDetailController? chatDetailController;
  final RxList<DriverInfoTagEntity> suggestedDrivers = RxList();
  final RxList<TruckInfoTagEntity> suggestedTrucks = RxList();
  final RxList<ShipmentInfoTagEntity> suggestedShipments = RxList();

  ///
  ///
  /// state variables

  final Rxn<DriverInfoTagEntity> selectedDriver = Rxn();
  final Rxn<TruckInfoTagEntity> selectedTruck = Rxn();
  final Rxn<ShipmentInfoTagEntity> selectedShipment = Rxn();

  final RxBool _isLoadingInfoTags = false.obs;
  bool get isLoadingInfoTags => _isLoadingInfoTags.value;

  final RxString driverSuggestionsHeading = "Drivers".obs;
  final RxString truckSuggestionsHeading = "Trucks".obs;
  final RxString shipmentSuggestionsHeading = "Shipments".obs;

  ///
  ///
  /// on init

  @override
  void onInit() {
    //
    // loading tags initial data
    _loadInfoTags();

    //
    // attach listeners for updating suggestions headings
    selectedDriver.listen((driver) {
      if (driver != null) {
        driverSuggestionsHeading.value = "Driver (${driver.name ?? ""})";
      }
    });
    selectedTruck.listen((truck) {
      if (truck != null) {
        truckSuggestionsHeading.value = "Truck (${truck.name ?? ""})";
      }
    });
    selectedShipment.listen((shipment) {
      if (shipment != null) {
        shipmentSuggestionsHeading.value =
            "Shipment (${shipment.shipmentNumber ?? ""})";
      }
    });

    super.onInit();
  }

  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////// data loading functions //////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////

  //
  //
  /// function that will pre load drivers and trucks and shipments
  /// for the info tags
  void _loadInfoTags() async {
    if (isLoadingInfoTags) {
      return;
    }
    _isLoadingInfoTags.value = true;
    try {
      final responses = await Future.wait([
        getChatInfoTagsUsercase.call("driver"),
        getChatInfoTagsUsercase.call("truck"),
        getChatInfoTagsUsercase.call("shipment")
      ]);

      //
      // loading drivers
      responses[0].fold((data) {
        if (data.driver.isNotEmpty == true) {
          chatInfoTags.value.driver.addAll(data.driver);
        }
      }, (_) {});

      //
      // loading trucks
      responses[1].fold((data) {
        if (data.truck.isNotEmpty == true) {
          chatInfoTags.value.truck.addAll(data.truck);
        }
      }, (_) {});

      //
      // loading shipments
      responses[2].fold((data) {
        if (data.shipment.isNotEmpty == true) {
          chatInfoTags.value.shipment.addAll(data.shipment);
        }
      }, (_) {});
    } catch (_) {}
    _isLoadingInfoTags.value = false;
  }

  //
  //
  /// function to fetch the data list on the base of desired tag
  Future<ChatInfoTagsModel> _fetchTags(ChatInfoTags tagType) async {
    // ignore: prefer_const_constructors, prefer_const_literals_to_create_immutables
    final tags = ChatInfoTagsModel(driver: [], truck: [], shipment: []);

    if (isLoadingInfoTags) {
      return tags;
    }
    _isLoadingInfoTags.value = true;

    try {
      (await getChatInfoTagsUsercase.call(tagType.name)).fold((data) {
        if (data.driver.isNotEmpty) {
          tags.driver.addAll(data.driver);
        }
        if (data.truck.isNotEmpty) {
          tags.truck.addAll(data.truck);
        }
        if (data.shipment.isNotEmpty) {
          tags.shipment.addAll(data.shipment);
        }
      }, (_) {});
    } catch (_) {}
    _isLoadingInfoTags.value = false;
    return tags;
  }

  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  ////////////////////////// tags processing functions /////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////

  //
  //
  /// function to initialize the text controller and listener
  void initializeTextController(RichTextController richTextController) {
    this.richTextController = richTextController;
    this.richTextController.addListener(_onTextChanged);
  }

  //
  //
  /// listener initializer
  void _onTextChanged() {
    if (richTextController.text.trim().isNotEmpty) {
      _checkForInfoTags();
    }
  }

  //
  //
  /// function that will check that have a info tag char
  /// match using regix
  void _checkForInfoTags() {
    String text = richTextController.text;
    int cursorPos = richTextController.selection.baseOffset;

    // Find all formatting blocks (like *bold* or numbered lists)
    RegExp formattingRegex =
        RegExp(r'(\*[^*]+\*|_.*?_|\~.*?~|\* .+|\- .+|\d+\..+)');
    Iterable<Match> formattingMatches = formattingRegex.allMatches(text);

    // Now scan for queries: /something, $something, !something
    RegExp queryRegex = RegExp(r'(?<!\*|\_|\~|\d\.)[/$!]([\w-]+)');
    Iterable<Match> queryMatches = queryRegex.allMatches(text);

    if (queryMatches.isNotEmpty) {
      for (Match queryMatch in queryMatches) {
        try {
          int matchStart = queryMatch.start;
          int matchEnd = queryMatch.end;

          // Only proceed if cursor is currently "in" or just after this tag
          bool isCursorWithinTag =
              cursorPos >= matchStart && cursorPos <= matchEnd;

          if (!isCursorWithinTag) {
            continue; // Skip this tag; it's not being typed right now
          }

          String querySymbol = queryMatch.group(0)!; // Full match
          String queryText =
              queryMatch.group(1)!; // Extracted text after symbol

          // Also avoid if it's inside any formatting block
          bool isInsideFormatting = formattingMatches.any((formatMatch) =>
              formatMatch.start <= queryMatch.start &&
              formatMatch.end >= queryMatch.end);

          if (!isInsideFormatting) {
            _processInfoTag(querySymbol[0], queryText);
            break; // Only process one active tag at cursor
          }
        } catch (_) {}
      }
    }
  }

  //
  //
  /// function that process info tag on the bases of tag type and
  /// show suggestions
  void _processInfoTag(String symbol, String query) async {
    final tagType = ChatInfoTags.fromString(symbol);

    if (tagType == null) {
      return;
    }

    if (!(await _ensureHaveRequiredTagsData(tagType))) {
      return;
    }

    switch (tagType) {
      case ChatInfoTags.driver:
        await _filterDriverSuggestions(query);
        break;
      case ChatInfoTags.truck:
        await _filterTruckSuggestions(query);
        break;
      case ChatInfoTags.shipment:
        await _filterShipmentSuggestions(query);
        break;
    }
  }

  //
  //
  /// function that will ensure that data is loaded
  Future<bool> _ensureHaveRequiredTagsData(ChatInfoTags tagType) async {
    try {
      switch (tagType) {
        //
        // check if already drivers tags exist then return true else fetch
        // from api and return the true if found from api
        case ChatInfoTags.driver:
          if (chatInfoTags.value.driver.isNotEmpty) {
            return true;
          }
          final drivers = (await _fetchTags(tagType)).driver;
          if (drivers.isNotEmpty) {
            chatInfoTags.value.driver.clear();
            chatInfoTags.value.driver.addAll(drivers);
            return true;
          }
          break;

        //
        // check if already trucks tags exist then return true else fetch
        // from api and return the true if found from api
        case ChatInfoTags.truck:
          if (chatInfoTags.value.truck.isNotEmpty) {
            return true;
          }
          final trucks = (await _fetchTags(tagType)).truck;
          if (trucks.isNotEmpty) {
            chatInfoTags.value.truck.clear();
            chatInfoTags.value.truck.addAll(trucks);
            return true;
          }
          break;

        //
        // check if already shipments tags exist then return true else fetch
        // from api and return the true if found from api
        case ChatInfoTags.shipment:
          if (chatInfoTags.value.shipment.isNotEmpty) {
            return true;
          }
          final shipments = (await _fetchTags(tagType)).shipment;
          if (shipments.isNotEmpty) {
            chatInfoTags.value.shipment.clear();
            chatInfoTags.value.shipment.addAll(shipments);
            return true;
          }
          break;
      }
    } catch (_) {}
    return false;
  }

  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  ///////////////////// query suggestion filtering functions ///////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////

  //
  //
  /// funtion to filter the driver suggestion on the bases of query
  Future<void> _filterDriverSuggestions(String query) async {
    //
    // clear all suggestions before making new query search suggestions
    clearAllSuggestions();

    // validate data and params
    if (query.isEmpty) {
      return;
    }

    final haveDrivers = await _ensureHaveRequiredTagsData(ChatInfoTags.driver);
    if (!haveDrivers) {
      return;
    }

    //
    // filter driver suggestions according to query
    final searchQuery = query.toLowerCase();
    final filteredDrivers = chatInfoTags.value.driver.where((driver) {
      return (driver.name?.toLowerCase().contains(searchQuery) ?? false) ||
          (driver.phone?.toLowerCase().contains(searchQuery) ?? false);
    });
    suggestedDrivers.addAll(filteredDrivers);
  }

  //
  //
  /// funtion to filter the truck suggestion on the bases of query
  Future<void> _filterTruckSuggestions(String query) async {
    //
    // clear all suggestions before making new query search suggestions
    clearAllSuggestions();

    // validate data and params
    if (query.isEmpty) {
      return;
    }

    final haveTrucks = await _ensureHaveRequiredTagsData(ChatInfoTags.truck);
    if (!haveTrucks) {
      return;
    }

    //
    // filter trucks suggestions according to query
    final searchQuery = query.toLowerCase();
    final filteredTrucks = chatInfoTags.value.truck.where((truck) {
      return (truck.name?.toLowerCase().contains(searchQuery) ?? false) ||
          (truck.identifier?.toString().contains(searchQuery) ?? false);
    });
    suggestedTrucks.addAll(filteredTrucks);
  }

  //
  //
  /// funtion to filter the shipments suggestion on the bases of query
  Future<void> _filterShipmentSuggestions(String query) async {
    //
    // clear all suggestions before making new query search suggestions
    clearAllSuggestions();

    // validate data and params
    if (query.isEmpty) {
      return;
    }

    final haveShipments =
        await _ensureHaveRequiredTagsData(ChatInfoTags.shipment);
    if (!haveShipments) {
      return;
    }

    //
    // filter shipments suggestions according to query
    final searchQuery = query.toLowerCase();
    final filteredShipments = chatInfoTags.value.shipment.where((shipment) {
      return (shipment.shipmentNumber?.toLowerCase().contains(searchQuery) ??
              false) ||
          (shipment.trailerId?.toString().contains(searchQuery) ?? false);
    });
    suggestedShipments.addAll(filteredShipments);
  }

  //
  //
  /// function to clear all suggestions
  void clearAllSuggestions() {
    suggestedDrivers.clear();
    suggestedTrucks.clear();
    suggestedShipments.clear();
    selectedDriver.value = null;
    selectedTruck.value = null;
    selectedShipment.value = null;
    _resetSuggestionHeadings();
  }

  //
  //
  /// function to reset the suggestion heading
  void _resetSuggestionHeadings() {
    driverSuggestionsHeading.value = "Drivers";
    truckSuggestionsHeading.value = "Trucks";
    shipmentSuggestionsHeading.value = "Shipments";
  }

  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  ///////////////////// linked suggestion filtering functions //////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////

  //
  //
  /// function to filter the suggestions derived from driver
  /// or linked with driver
  void filterDriverLinkedSuggestions(
    int driverId,
    DriverLinkedTags tagType,
  ) async {
    // validate data and params
    if (driverId <= 0) {
      return;
    }

    final driver = chatInfoTags.value.driver
        .firstWhereOrNull((item) => item.id == driverId);

    if (driver == null) {
      return;
    }

    if (tagType == DriverLinkedTags.trucks) {
      //
      // clear previous suggestions
      selectedTruck.value = null;
      suggestedTrucks.clear();

      //
      // check and filter linked trucks suggestion
      final haveTrucks = await _ensureHaveRequiredTagsData(ChatInfoTags.truck);
      if (haveTrucks) {
        //
        // filter trucks having current driverId in its drivers list
        final linkedTrucks = chatInfoTags.value.truck.where((truck) {
          final truckDrivers = truck.drivers?.map((item) => item.id);
          return truckDrivers?.contains(driverId) ?? false;
        });

        if (linkedTrucks.isNotEmpty) {
          truckSuggestionsHeading.value =
              "Driver Trucks (${driver.name ?? ""})";
          suggestedTrucks.addAll(linkedTrucks);
        }
      }
    } else if (tagType == DriverLinkedTags.shipments) {
      //
      // clear previous suggestions
      selectedShipment.value = null;
      suggestedShipments.clear();

      //
      // check and filter linked shipments suggestion
      final haveShipments =
          await _ensureHaveRequiredTagsData(ChatInfoTags.shipment);
      if (haveShipments) {
        //
        // filter shipments having current driverId in his drivers list
        final linkedShipments = chatInfoTags.value.shipment.where((shipment) {
          final shipmentDrivers = shipment.drivers?.map((item) => item.id);
          return shipmentDrivers?.contains(driverId) ?? false;
        });

        if (linkedShipments.isNotEmpty) {
          shipmentSuggestionsHeading.value =
              "Driver Shipments (${driver.name ?? ""})";
          suggestedShipments.addAll(linkedShipments);
        }
      }
    }
  }

  //
  //
  /// function to filter the suggestions derived from truck
  /// or linked with truck
  void filterTruckLinkedSuggestions(
    int truckId,
    TruckLinkedTags tagType,
  ) async {
    // validate data and params
    if (truckId <= 0) {
      return;
    }

    final truck =
        chatInfoTags.value.truck.firstWhereOrNull((item) => item.id == truckId);

    if (truck == null) {
      return;
    }

    //
    // clear previous suggestions
    if (tagType == TruckLinkedTags.drivers) {
      //
      // clear previous suggestions
      selectedDriver.value = null;
      suggestedDrivers.clear();

      //
      // check and filter linked drivers suggestion
      if (truck.drivers?.isNotEmpty ?? false) {
        driverSuggestionsHeading.value =
            "Truck Drivers (${truck.identifier ?? ""})";
        suggestedDrivers.addAll(truck.drivers ?? []);
      }
    } else if (tagType == TruckLinkedTags.shipments) {
      //
      // clear previous suggestions
      selectedShipment.value = null;
      suggestedShipments.clear();

      //
      // check and filter linked shipments suggestion
      final haveShipments =
          await _ensureHaveRequiredTagsData(ChatInfoTags.shipment);
      if (haveShipments) {
        //
        // filter shipments having current truckId in its trucks list
        final linkedShipments = chatInfoTags.value.shipment.where((shipment) {
          final shipmentTrucks = shipment.trucks?.map((item) => item.id);
          return shipmentTrucks?.contains(truckId) ?? false;
        });

        if (linkedShipments.isNotEmpty) {
          shipmentSuggestionsHeading.value =
              "Truck Shipments (${truck.identifier ?? ""})";
          suggestedShipments.addAll(linkedShipments);
        }
      }
    }
  }

  //
  //
  /// function to filter the suggestions derived from shipment
  /// or linked with shipment
  void filterShipmentLinkedSuggestions(
    int shipmentId,
    ShipmentLinkedTags tagType,
  ) async {
    // validate data and params
    if (shipmentId <= 0) {
      return;
    }

    final shipment = chatInfoTags.value.shipment
        .firstWhereOrNull((item) => item.id == shipmentId);

    if (shipment == null) {
      return;
    }

    //
    // clear previous suggestions
    if (tagType == ShipmentLinkedTags.drivers) {
      //
      // clear previous suggestions
      selectedDriver.value = null;
      suggestedDrivers.clear();

      //
      // check and filter linked drivers suggestion
      if (shipment.drivers?.isNotEmpty ?? false) {
        driverSuggestionsHeading.value =
            "Shipment Drivers (${shipment.shipmentNumber ?? ""})";
        suggestedDrivers.addAll(shipment.drivers ?? []);
      }
    } else if (tagType == ShipmentLinkedTags.trucks) {
      //
      // clear previous suggestions
      selectedTruck.value = null;
      suggestedTrucks.clear();

      //
      // check and filter linked trucks suggestion
      if (shipment.trucks?.isNotEmpty ?? false) {
        truckSuggestionsHeading.value =
            "Shipment Trucks (${shipment.shipmentNumber ?? ""})";
        suggestedTrucks.addAll(shipment.trucks ?? []);
      }
    }
  }

  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  /////////////////////// suggestion insertion functions ///////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////

  //
  //
  /// function that will insert driver name and phone number and
  /// also update trucks and shipments and locations suggestions
  void insertDriveSuggestion(DriverInfoTagEntity driver) {
    selectedDriver.value = driver;
    suggestedDrivers.clear();

    String text = richTextController.text;
    int cursorPos = richTextController.selection.baseOffset;

    // Check for existing active tag at the cursor
    RegExp queryRegex = RegExp(r'(?<!\*|\_|\~|\d\.)[/$!]([\w-]+)');
    Iterable<Match> queryMatches = queryRegex.allMatches(text);

    for (Match match in queryMatches) {
      int start = match.start;
      int end = match.end;

      // Check if cursor is inside or right after a tag
      if (cursorPos >= start && cursorPos <= end) {
        insertText("!${(driver.name ?? "").trim()}!", start: start, end: end);
        return;
      }
    }

    // No active tag, insert at cursor
    insertText("!${(driver.name ?? "").trim()}!");
  }

  //
  //
  /// function that will insert truck number and
  /// also update drivers and shipments and locations suggestions
  void insertTruckSuggestion(TruckInfoTagEntity truck) {
    selectedTruck.value = truck;
    suggestedTrucks.clear();

    String text = richTextController.text;
    int cursorPos = richTextController.selection.baseOffset;

    // Check for existing active tag at the cursor
    RegExp queryRegex = RegExp(r'(?<!\*|\_|\~|\d\.)[/$!]([\w-]+)');
    Iterable<Match> queryMatches = queryRegex.allMatches(text);

    for (Match match in queryMatches) {
      int start = match.start;
      int end = match.end;

      // Check if cursor is inside or right after a tag
      if (cursorPos >= start && cursorPos <= end) {
        insertText("/${(truck.name ?? "").trim()}/", start: start, end: end);
        return;
      }
    }

    // No active tag, insert at cursor
    insertText("/${(truck.name ?? "").trim()}/");
  }

  //
  //
  /// function that will insert shipment number and
  /// also update drivers and trucks and locations suggestions
  void insertShipmentSuggestion(ShipmentInfoTagEntity shipment) {
    selectedShipment.value = shipment;
    suggestedShipments.clear();

    String text = richTextController.text;
    int cursorPos = richTextController.selection.baseOffset;

    // Check for existing active tag at the cursor
    RegExp queryRegex = RegExp(r'(?<!\*|\_|\~|\d\.)[/$!]([\w-]+)');
    Iterable<Match> queryMatches = queryRegex.allMatches(text);

    for (Match match in queryMatches) {
      int start = match.start;
      int end = match.end;

      // Check if cursor is inside or right after a tag
      if (cursorPos >= start && cursorPos <= end) {
        insertText("\$${(shipment.shipmentNumber ?? "").trim()}\$",
            start: start, end: end);
        return;
      }
    }

    // No active tag, insert at cursor
    insertText("\$${(shipment.shipmentNumber ?? "").trim()}\$");
  }

  //
  //
  /// function to insert the text on cursor current location
  void insertText(String textToInsert, {int? start, int? end}) {
    textToInsert += " ";
    String originalText = richTextController.text;
    int textLength = originalText.length;
    int cursorPos = richTextController.selection.baseOffset;

    // Determine valid range
    bool isValidRange = start != null &&
        end != null &&
        start >= 0 &&
        end >= start &&
        end <= textLength;
    int insertStart = isValidRange ? start : cursorPos;
    int insertEnd = isValidRange ? end : cursorPos;

    // Smart spacing around the insert
    String beforeInsert =
        insertStart > 0 && originalText[insertStart - 1] != ' ' ? ' ' : '';
    String afterInsert =
        insertEnd < textLength && originalText[insertEnd] != ' ' ? ' ' : '';

    // Final insert content
    String finalInsert = '$beforeInsert$textToInsert$afterInsert';

    // Perform the insert
    String updatedText =
        originalText.replaceRange(insertStart, insertEnd, finalInsert);

    // Update controller and cursor
    int newCursorPos = insertStart + finalInsert.length;

    richTextController.value = TextEditingValue(
      text: updatedText,
      selection: TextSelection.collapsed(offset: newCursorPos),
    );
  }

  @override
  void onClose() async {
    //
    super.onClose();
  }
}
