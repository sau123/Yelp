### Yelp

This is an example of how to implement an OAuth 1.0a Yelp API client. The Yelp API provides an application token that allows applications to make unauthenticated requests to their search API. It includes the following features :


User Stories
The following user stories must be completed:

* [x] Search results page
* [x] Table rows should be dynamic height according to the content height.
* [x] Custom cells should have the proper Auto Layout constraints.
* [x] Search bar should be in the navigation bar (doesn't have to expand to show location like the real Yelp app does).

* [ ] Optional: Infinite scroll for restaurant results
* [x] Optional: Implement map view of restaurant results
* [x] Filter page. Unfortunately, not all the filters in the real Yelp App, are supported in the Yelp API.
* [x] The filters you should actually have are: category, sort (best match, distance, highest rated), distance, deals (on/off).
* [x] The filters table should be organized into sections as in the mock.
* [x] You can use the default UISwitch for on/off states. Optional: implement a custom switch
* [x] Clicking on the "Search" button should dismiss the filters page and trigger the search w/ the new filter settings.
* [ ] Optional: Distance filter should expand as in the real Yelp app.
* [ ] Optional: Categories should show a subset of the full list with a "See All" row to expand.
* [x] Optional: Implement the restaurant detail page.

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

![](./Yelp.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).



###Note
### Sample request

**Basic search with query**

```
Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
    self.businesses = businesses
    
    for business in businesses {
        print(business.name!)
        print(business.address!)
    }
})
```

**Advanced search with categories, sort, and deal filters**

```
Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in

    for business in businesses {
        print(business.name!)
        print(business.address!)
    }
}
```
