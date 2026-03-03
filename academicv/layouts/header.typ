// Job titles
#let jobtitle-text(data, settings) = {
    if ("titles" in data.personal and data.personal.titles != none) {
        block(width: 100%)[
            #text(weight: "semibold", data.personal.titles.join("  /  "))
            #v(-4pt)
        ]
    } else {none}
}

// Address
#let address-text(data, settings) = {
    if ("location" in data.personal and data.personal.location != none) {
        // Filter out empty address fields
        let address = data.personal.location.pairs().filter(it => it.at(1) != none and str(it.at(1)) != "")
        // Join non-empty address fields with commas
        let location = address.map(it => str(it.at(1))).join(", ")

        block(width: 100%)[
            #location
            #v(-4pt)
        ]
    } else {none}
}

#let phone-to-tel(phone) = {
    if phone == none { none } else {
        let raw = str(phone)
        let cleaned0 = raw.replace(regex("[^0-9+]"), "")
        let cleaned = if cleaned0.starts-with("+") {
            "+" + cleaned0.slice(1).replace("+", "")
        } else {
            cleaned0.replace("+", "")
        }
        if cleaned == "" { none } else { "tel:" + cleaned }
    }
}

#let contact-text(data, settings) = block(width: 100%)[
    #let profiles = (
        if "email" in data.personal.contact and data.personal.contact.email != none {
            box[
                #link("mailto:" + data.personal.contact.email)[#data.personal.contact.email]
            ]
        },
        if ("phone" in data.personal.contact and data.personal.contact.phone != none) {
            let tel = phone-to-tel(data.personal.contact.phone)
            if tel != none {
                box[
                    #link(tel)[#data.personal.contact.phone]
                ]
            } else {
                box[
                    #data.personal.contact.phone
                ]
            }
        } else {none},
        if ("website" in data.personal.contact) and (data.personal.contact.website != none) {
            let url = str(data.personal.contact.website)
            let disp = if url.contains("://") { url.split("://").at(1) } else { url }
            box[
                #link(url)[#disp]
            ]
        }
    ).filter(it => it != none) // Filter out none elements from the profile array

    #if ("profiles" in data.personal) and (data.personal.profiles.len() > 0) {
        for profile in data.personal.profiles {
            let url = str(profile.url)
            let disp = if url.contains("://") { url.split("://").at(1) } else { url }
            profiles.push(
                box[
                    #link(url)[#disp]
                ]
            )
        }
    }

    #set text(font: settings.font-body, weight: "medium", size: settings.fontsize)
    #pad(x: 0em)[
        #profiles.join([#sym.space.en | #sym.space.en])
    ]
]


#let layout-header(data, settings, isbreakable: true) = {

    align(center)[
        = #data.personal.name

        #for section in data.sections.filter(s => s.layout == "header" and s.show == true) {
            if "include" in section {
                for item in section.include {
                    if item == "titles" {
                        jobtitle-text(data, settings)
                    }
                    
                    if item == "location" {
                        address-text(data, settings)
                    }
                    
                    if item == "contact" {
                        contact-text(data, settings)
                    }
                }
            }
        }
    ]
}
