using DevExpress.Web.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace LSExt.Controllers
{
	public class HomeController : Controller
	{
		public ActionResult Index()
		{
			return View();
		}

		LSExt.Models.rPersonalDBDataContext db = new LSExt.Models.rPersonalDBDataContext();

		[ValidateInput(false)]
		public ActionResult GridViewPartial()
		{
			var model = db.rPersonals;
			return PartialView("_GridViewPartial", model);
		}

		[HttpPost, ValidateInput(false)]
		public ActionResult GridViewPartialAddNew([ModelBinder(typeof(DevExpressEditorsBinder))] LSExt.Models.rPersonal item)
		{
			var model = db.rPersonals;
			if (ModelState.IsValid)
			{
				try
				{
					model.InsertOnSubmit(item);
					db.SubmitChanges();
				}
				catch (Exception e)
				{
					ViewData["EditError"] = e.Message;
				}
			}
			else
				ViewData["EditError"] = "Please, correct all errors.";
			return PartialView("_GridViewPartial", model);
		}
		[HttpPost, ValidateInput(false)]
		public ActionResult GridViewPartialUpdate([ModelBinder(typeof(DevExpressEditorsBinder))] LSExt.Models.rPersonal item)
		{
			var model = db.rPersonals;
			if (ModelState.IsValid)
			{
				try
				{
					var modelItem = model.FirstOrDefault(it => it.id == item.id);
					if (modelItem != null)
					{
						this.UpdateModel(modelItem);
						db.SubmitChanges();
					}
				}
				catch (Exception e)
				{
					ViewData["EditError"] = e.Message;
				}
			}
			else
				ViewData["EditError"] = "Please, correct all errors.";
			return PartialView("_GridViewPartial", model);
		}
		[HttpPost, ValidateInput(false)]
		public ActionResult GridViewPartialDelete(System.Int64 id)
		{
			var model = db.rPersonals;
			if (id >= 0)
			{
				try
				{
					var item = model.FirstOrDefault(it => it.id == id);
					if (item != null)
						model.DeleteOnSubmit(item);
					db.SubmitChanges();
				}
				catch (Exception e)
				{
					ViewData["EditError"] = e.Message;
				}
			}
			return PartialView("_GridViewPartial", model);
		}
	}
}