using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using LSExt.Models;
using DevExtreme.AspNet.Data;

namespace LSExt.Controllers
{
	public class OrdersController : ApiController
	{

		[HttpGet]
		public HttpResponseMessage Get(DataSourceLoadOptions loadOptions)
		{
			return Request.CreateResponse(DataSourceLoader.Load(SampleData.Orders, loadOptions));
		}

	}
}