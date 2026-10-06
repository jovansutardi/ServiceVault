# ServiceVault

ServiceVault is an iOS application designed to help private vehicle owners keep a reliable digital record of vehicle maintenance, service history, upcoming maintenance requirements, and supporting service documents.

The application uses a domain-centred architecture with SwiftUI, MVVM, Use Cases, Repository protocols, Core Data, WidgetKit, a Share Extension, and an App Group shared container.

---

## Domain Context

Vehicle maintenance information is often fragmented across paper receipts, workshop invoices, email attachments, photos, notes, and memory.

This creates several practical problems for vehicle owners:

- service history can be incomplete or difficult to locate
- invoices and maintenance evidence can be lost
- upcoming servicing can be forgotten
- odometer-based maintenance requirements can be difficult to track
- information from different workshops is stored in different places

ServiceVault provides one structured location for recording maintenance history and keeping supporting service evidence associated with the correct maintenance record.

---

## Primary Stakeholder

The primary stakeholder is a private vehicle owner who services and maintains their vehicle across different workshops and needs a reliable record of:

- completed maintenance
- vehicle odometer history
- upcoming maintenance
- workshop information
- service costs
- supporting invoices and documents

---

## Architecture

ServiceVault uses a domain-centred MVVM architecture.

```text
SwiftUI Views
        ↓
ViewModels
        ↓
Use Cases
        ↓
Repository Protocols
        ↓
Core Data Repository Implementations
        ↓
Core Data
