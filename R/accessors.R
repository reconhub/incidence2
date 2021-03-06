#' Access various elements of an incidence object
#'
#' @param x An [incidence()] object.
#' @param ... Not used.
#'
#' @examples
#' if (requireNamespace("outbreaks", quietly = TRUE)) {
#'   withAutoprint({
#'     data(ebola_sim_clean, package = "outbreaks")
#'     dat <- ebola_sim_clean$linelist
#'     i <- incidence(dat,
#'                    date_index = date_of_onset,
#'                    groups = c(gender, hospital))
#'
#'     get_counts(i)
#'     get_count_names(i)
#'
#'     get_group_names(i)
#'
#'     get_date_index(i)
#'     get_dates_name(i)
#'
#'     get_interval(i)
#'
#'     get_n(i)
#'
#'     get_timespan(i)
#'   })
#' }
#'
#' @name accessors
NULL


# -------------------------------------------------------------------------
#' @return
#'   - `get_counts`: The count vector from x.
#' @aliases get_counts
#' @export
#' @rdname accessors
get_counts <- function(x, ...) {
  UseMethod("get_counts")
}

#' @rdname accessors
#' @aliases get_counts.default
#' @export
get_counts.default <- function(x, ...) {
  abort(
    sprintf("Not implemented for class %s", paste(class(x), collapse = ", "))
  )
}

#' @rdname accessors
#' @aliases get_counts.incidence_df
#' @export
get_counts.incidence_df <- function(x, ...) {
  ellipsis::check_dots_empty()
  x[[attr(x, "counts")]]
}
# -------------------------------------------------------------------------


# -------------------------------------------------------------------------
#' @return
#'   - `get_count_names()`: The name of the count variable of x.
#' @aliases get_count_names
#' @rdname accessors
#' @export
get_count_names <- function(x, ...) {
  UseMethod("get_count_names")
}

#' @rdname accessors
#' @aliases get_count_names.default
#' @export
get_count_names.default <- function(x, ...) {
  abort(
    sprintf("Not implemented for class %s", paste(class(x), collapse = ", "))
  )
}

#' @rdname accessors
#' @aliases get_count_names.incidence_df
#' @export
get_count_names.incidence_df <- function(x, ...) {
  ellipsis::check_dots_empty()
  attr(x, "counts")
}
# -------------------------------------------------------------------------


# -------------------------------------------------------------------------
#' @return
#'   - `get_date_index()`: The date_index vector from x.
#' @rdname accessors
#' @aliases get_date_index
#' @export
get_date_index <- function(x, ...) {
  UseMethod("get_date_index")
}

#' @rdname accessors
#' @aliases get_date_index.default
#' @export
get_date_index.default <- function(x, ...) {
  abort(
    sprintf("Not implemented for class %s", paste(class(x), collapse = ", "))
  )
}

#' @rdname accessors
#' @aliases get_date_index.incidence_df
#' @export
get_date_index.incidence_df <- function(x, ...) {
  ellipsis::check_dots_empty()
  x[[attr(x, "date")]]
}

#' @return
#'   - `get_dates()`: Same as `get_date_index()`.
#' @rdname accessors
#' @aliases get_dates
#' @export
get_dates <- get_date_index
# -------------------------------------------------------------------------


# -------------------------------------------------------------------------
#' @return
#'   - `get_dates_name()`: The name of the date_index variable of x.
#' @rdname accessors
#' @aliases get_dates_name
#' @export
get_dates_name <- function(x, ...) {
  UseMethod("get_dates_name")
}

#' @rdname accessors
#' @aliases get_dates_name.default
#' @export
get_dates_name.default <- function(x, ...) {
  abort(
    sprintf("Not implemented for class %s", paste(class(x), collapse = ", "))
  )
}

#' @rdname accessors
#' @aliases get_dates_name.incidence_df
#' @export
get_dates_name.incidence_df <- function(x, ...) {
  ellipsis::check_dots_empty()
  attr(x, "date")
}
# -------------------------------------------------------------------------


#' @return
#'   - `get_group_names()`: a character vector of the group variables of x or
#'   NULL if none are present.
#' @rdname accessors
#' @aliases get_group_names
#' @export
get_group_names <- function(x, ...) {
  UseMethod("get_group_names")
}

#' @rdname accessors
#' @aliases get_group_names.default
#' @export
get_group_names.default <- function(x, ...) {
  abort(
    sprintf("Not implemented for class %s", paste(class(x), collapse = ", "))
  )
}

#' @rdname accessors
#' @aliases get_group_names.incidence_df
#' @export
get_group_names.incidence_df <- function(x, ...) {
  ellipsis::check_dots_empty()
  attr(x, "groups")
}
# -------------------------------------------------------------------------


# -------------------------------------------------------------------------
#' @return
#'   - `get_timespan()`: an `integer` denoting the timespan in days represented
#'   by the incidence object.
#' @rdname accessors
#' @aliases get_timespan
#' @export
get_timespan <- function(x, ...) {
  UseMethod("get_timespan")
}

#' @rdname accessors
#' @aliases get_timespan.default
#' @export
get_timespan.default <- function(x, ...) {
  abort(
    sprintf("Not implemented for class %s", paste(class(x), collapse = ", "))
  )
}

#' @rdname accessors
#' @aliases get_timespan.incidence2
#' @export
get_timespan.incidence2 <- function(x, ...) {
  ellipsis::check_dots_empty()
  date_var <- get_dates_name(x)
  dat <- x[[date_var]]
  if(inherits(dat, "Date") || inherits(dat, "numeric")) {
    out <- max(dat) - min(dat)
  } else {
    bounds <- grates::get_date_range(dat)
    out <- bounds[2] - bounds[1]
  }
  out + 1
}
# -------------------------------------------------------------------------


# -------------------------------------------------------------------------
#' @return
#'   - `get_n()` The total number of cases stored in the object
#' @export
#' @rdname accessors
#' @aliases get_n
get_n <- function(x) {
  UseMethod("get_n")
}

#' @export
#' @rdname accessors
#' @aliases get_n.default
get_n.default <- function(x) {
  abort(
    sprintf("Not implemented for class %s", paste(class(x), collapse = ", "))
  )
}

#' @export
#' @rdname accessors
#' @aliases get_n.incidence_df
get_n.incidence_df <- function(x) {
  count_var <- get_count_names(x)
  colSums(x[count_var])
}
# -------------------------------------------------------------------------

#' @return
#'   - `get_interval()`: if `integer = TRUE`, an integer vector, otherwise the
#'     character value of the `interval`
#' @aliases get_interval
#' @rdname accessors
#' @export
get_interval <- function(x, ...) {
  UseMethod("get_interval")
}

#' @export
#' @rdname accessors
#' @aliases get_interval.default
get_interval.default <- function(x, ...) {
  abort(
    sprintf("Not implemented for class %s", paste(class(x), collapse = ", "))
  )
}

#' @export
#' @rdname accessors
#' @aliases get_interval.incidence2
get_interval.incidence2 <- function(x, ...) {
  ellipsis::check_dots_empty()
  interval <- attr(x, "interval")

}


# -------------------------------------------------------------------------

#' Deprecated accessor functions
#'
#' These accessor functions have now been deprecated in favour of better
#'   named alternatives but are left available for backwards compatibility.
#'
#' @param x An [incidence()] object.
#' @param ... Not used.
#'
#' @examples
#' if (requireNamespace("outbreaks", quietly = TRUE)) {
#'   withAutoprint({
#'     data(ebola_sim_clean, package = "outbreaks")
#'     dat <- ebola_sim_clean$linelist
#'     i <- incidence(dat,
#'                    date_index = date_of_onset,
#'                    groups = c(gender, hospital))
#'
#'     get_counts_name(i)
#'
#'     get_date_group_names(i)
#'   })
#' }
#'
#' @name deprecated-accessors
#' @keywords internal
NULL


#' @return
#'   - `get_counts_name()`: Same as `get_count_names()`.
#' @keywords internal
#' @export
#' @rdname deprecated-accessors
get_counts_name <- get_count_names # for backwards compatibility


#' @return
#'   - `get_date_group_names()`: Same as `get_dates_name()`
#' @rdname deprecated-accessors
#' @keywords internal
#' @export
get_date_group_names <- get_dates_name # for backwards compatibility

